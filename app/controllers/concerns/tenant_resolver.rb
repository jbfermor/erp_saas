class TenantResolver
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    subdomain = request.subdomain

    if subdomain.present? && subdomain != "www"
      # Buscar account en la base SaaS
      account = Saas::Account.find_by(subdomain: subdomain)

      if account&.saas_tenant_database
        # Guardar datos de conexión en el env
        env["tenant_db_config"] = account.saas_tenant_database.connection_hash
      end
    end

    @app.call(env)
  end
end
