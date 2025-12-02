class TenantSubdomainMiddleware

  NON_TENANT_HOSTS = [
    "localhost",
    "127.0.0.1",
  ].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    host = request.host

    Rails.logger.info "🌐 Host recibido: #{host}"

    # 🔥 1) Si el host pertenece al SaaS global → NO intentar tenant
    if NON_TENANT_HOSTS.include?(host)
      Rails.logger.info "🏛  Host #{host} es PRIMARIO del SaaS → no conectar tenant"
      return @app.call(env)
    end

    # 🔥 2) Buscar tenant por host completo
    tenant_db = Saas::TenantDatabase.find_by(host: host)

    unless tenant_db
      Rails.logger.error "❌ No existe configuración tenant para host #{host}"
      return not_found_response
    end

    tenant_config = {
      adapter:  "postgresql",
      host:     tenant_db.host,
      port:     tenant_db.port,
      database: tenant_db.database_name,
      username: tenant_db.username,
      password: tenant_db.password,
      encoding: "unicode",
      pool:     ENV.fetch("RAILS_MAX_THREADS", 5)
    }.deep_symbolize_keys

    Rails.logger.info "🔄 Conectando TENANT para #{host}"

    ActiveRecord::Base.establish_connection(tenant_config)

    result = @app.call(env)
    result
  ensure
    Rails.logger.info "🔙 Restaurando conexión PRIMARIA"
    ActiveRecord::Base.establish_connection(primary_config)
  end

  private

  def primary_config
    cfg = Rails.configuration.database_configuration[Rails.env]
    cfg = cfg["primary"] if cfg.is_a?(Hash) && cfg.key?("primary")
    cfg
  end

  def not_found_response
    [
      404,
      { "Content-Type" => "text/html" },
      ["Tenant host no encontrado"]
    ]
  end
end
