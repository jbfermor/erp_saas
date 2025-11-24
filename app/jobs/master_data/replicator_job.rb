module MasterData
  class ReplicatorJob < ApplicationJob
    queue_as :default

    # klass_name: "MasterData::Module" or "MasterData::Plan" or "MasterData::PlanModule"
    # record_id: uuid
    # action: "upsert" or "destroy"
    def perform(klass_name, record_id, action: "upsert")
      klass = klass_name.constantize
      record = begin
        klass.unscoped.find_by(id: record_id)
      rescue => e
        Rails.logger.error("Replicator: error fetching #{klass_name} #{record_id}: #{e.message}")
        nil
      end

      # Repliacate to each tenant database
      Saas::TenantDatabase.find_each do |td|
        replicate_to_tenant(td, klass_name, record, action)
      end
    end

    private

    def replicate_to_tenant(tenant_db, klass_name, record, action)
      conn_hash = tenant_db.connection_hash

      begin
        ActiveRecord::Base.establish_connection(conn_hash)

        tenant_klass = klass_name.constantize
        case action
        when "upsert"
          attrs = record.attributes.except("id", "created_at", "updated_at")
          # We want deterministic id? We'll preserve the same id to keep referential integrity across tenants
          tenant_record = tenant_klass.find_or_initialize_by(id: record.id)
          tenant_record.assign_attributes(attrs)
          tenant_record.save!(validate: false)
        when "destroy"
          tenant_klass.where(id: record&.id).delete_all
        else
          Rails.logger.warn("ReplicatorJob unknown action #{action}")
        end
      rescue => e
        Rails.logger.error("ReplicatorJob failed for tenant #{tenant_db.database_name}: #{e.message}")
      ensure
        # reconnect to default (app primary)
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)
      end
    end
  end
end
