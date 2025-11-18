# app/services/master_data/seeder.rb
module MasterData
  class Seeder
    def initialize(account)
      @account = account
      @tenant_db = account.tenant_database
      raise ArgumentError, "Account has no tenant database" unless @tenant_db
    end

    # Punto de entrada
    def seed!
      Rails.logger.info("🌱 Replicando master_data para tenant #{@account.slug}...")

      base_url = connection_url_for(@tenant_db)

      # Conectamos a la base global (SaaS principal)
      ActiveRecord::Base.connected_to(role: :writing) do
        # Modelos que queremos replicar
        master_models.each do |model_class|
          replicate_model_to_tenant(model_class, base_url)
        end
      end

      Rails.logger.info("✅ MasterData replicado correctamente en #{@account.slug}")
    end

    private

    # Modelos que forman parte de master_data
    def master_models
      [
        MasterData::Country,
        MasterData::Role,
        MasterData::EntityType,
        MasterData::DocumentType
      ]
    end

    def connection_url_for(tenant_db)
      "postgres://#{tenant_db.username}:#{tenant_db.password}@#{tenant_db.host}/#{tenant_db.database_name}"
    end

    # Copia los datos de un modelo desde la DB principal hacia la DB del tenant
    def replicate_model_to_tenant(model_class, tenant_url)
      records = model_class.all

      Rails.logger.info("📦 Replicando #{records.size} registros de #{model_class.name}...")

      ActiveRecord::Base.connected_to(database: { writing: tenant_url }) do
        tenant_model = model_class
        tenant_model.delete_all # limpiar primero para evitar duplicados
        records.each do |record|
          tenant_model.create!(record.attributes.except("id", "created_at", "updated_at"))
        end
      end
    end
  end
end
