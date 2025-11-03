# lib/tenant_switcher.rb
# Switch simple de conexión para el seeding. Asegura restore de conexión primaria.
module TenantSwitcher
  def self.switch(account)
    db = account.tenant_database
    raise "Tenant database not configured for #{account.slug}" unless db

    config = {
      adapter:  "postgresql",
      host:     db.host,
      port:     db.port,
      username: db.username,
      password: db.password,
      database: db.database_name,
      encoding: "utf8",
      pool:     ENV.fetch("DB_POOL", 5)
    }

    # Guardamos la conexión actual y establecemos la nueva
    original_config = ActiveRecord::Base.connection_db_config

    ActiveRecord::Base.establish_connection(config)
    yield
  ensure
    # Restaurar conexión primaria (asume :primary configurado en database.yml)
    ActiveRecord::Base.establish_connection(original_config)
  end
end
