class TenantSubdomainMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    subdomain = extract_subdomain(request)

    if subdomain.present? && subdomain != "www"
      account = Saas::Account.find_by(subdomain: subdomain)
      return not_found if account.nil?

      db_config = account.saas_tenant_database
      return db_not_configured if db_config.nil?

      activate_tenant_connection(db_config)
      Thread.current[:current_tenant_account] = account
    else
      clear_tenant_connection
    end

    @app.call(env)

  ensure
    clear_tenant_connection
  end

  private

  def extract_subdomain(request)
    host = request.host
    parts = host.split(".")
    return nil if parts.length < 3
    parts.first
  end

  def activate_tenant_connection(db_config)
    ActiveRecord::Base.establish_connection(
      adapter:  "postgresql",
      host:     db_config.host,
      port:     db_config.port,
      database: db_config.database_name,
      username: db_config.username,
      password: db_config.password,
      encoding: "unicode",
      pool:     5
    )

    Thread.current[:tenant_db_active] = true

  end

  def clear_tenant_connection
    return unless Thread.current[:tenant_db_active]

    # reconectar a la DB global (saas)
    ActiveRecord::Base.establish_connection(:primary)

    Thread.current[:tenant_db_active] = nil
    Thread.current[:current_tenant_account] = nil
  end

  def not_found
    [404, { "Content-Type" => "text/plain" }, ["Tenant not found"]]
  end

  def db_not_configured
    [500, { "Content-Type" => "text/plain" }, ["Tenant database not configured"]]
  end
end
