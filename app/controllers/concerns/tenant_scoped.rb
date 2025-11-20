module TenantScoped
  extend ActiveSupport::Concern

  included do
    before_action :switch_to_tenant_db
  end

  def switch_to_tenant_db
    account = request.env["saas.current_account"]
    return unless account.present?

    tenant_db = account.tenant_database
    ActiveRecord::Base.establish_connection(tenant_db.connection_hash)
  end
end
