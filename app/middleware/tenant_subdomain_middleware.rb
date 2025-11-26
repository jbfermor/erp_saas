class TenantSubdomainMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request   = ActionDispatch::Request.new(env)
    subdomain = extract_subdomain(request.host)

    # Si no hay subdominio → pasa a la app pública
    return @app.call(env) if subdomain.nil?

    TenantContext.switch(subdomain) do
      @app.call(env)
    end
  end

  private

  def extract_subdomain(host)
    host = host.split(":").first

    # 1. Ignorar localhost puro
    return nil if host == "localhost"

    # 2. Ignorar IPs (como 127.0.0.1 o ::1)
    return nil if host.match?(/\A\d{1,3}(\.\d{1,3}){3}\z/) # IPv4
    return nil if host == "::1"                            # IPv6

    # 3. Para lvh.me / localtest.me / dominios reales
    parts = host.split(".")

    # Debe tener al menos 3 partes → subdominio.dominio.tld
    return nil if parts.length < 3

    subdomain = parts.first

    # Ignorar "www"
    return nil if subdomain == "www"

    subdomain
  end

end
