module TenantContext
  def self.switch(slug)
    account = Saas::Account.find_by(slug: slug)
    raise "Tenant '#{slug}' not found" unless account

    tenant_db = account.saas_tenant_database
    raise "Tenant '#{slug}' has no database config" unless tenant_db

    cfg = {
      adapter:  tenant_db.adapter,
      host:     tenant_db.host,
      port:     tenant_db.port,
      username: tenant_db.username,
      password: tenant_db.password,
      database: tenant_db.database_name
    }.compact

    original = ActiveRecord::Base.connection_db_config

    ActiveRecord::Base.establish_connection(cfg)

    yield
  ensure
    ActiveRecord::Base.establish_connection(original)
  end
end
