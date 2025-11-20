class TenantResolver
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    subdomain = extract_subdomain(request.host)

    if subdomain.present? && subdomain != "www"
      account = Saas::Account.find_by(subdomain: subdomain)

      if account
        env["saas.current_account"] = account
      end
    end

    @app.call(env)
  end

  private

  def extract_subdomain(host)
    parts = host.split(".")
    return nil if parts.length < 3
    parts.first
  end
end
