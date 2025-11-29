# app/middleware/tenant_subdomain_middleware.rb
class TenantSubdomainMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    subdomain = extract_subdomain(req.host)
    if subdomain.present? && subdomain != 'www' && subdomain != Rails.application.config.main_domain
      tenant = Saas::Account.find_by(subdomain: subdomain)
      # No uses global Current; pon en env para scoping manual
      env['current_tenant'] = tenant
    end

    @app.call(env)
  end

  private

  def extract_subdomain(host)
    # lvh.me -> host can be "cliente.lvh.me:3000", normaliza
    host.split('.').first
  end
end
