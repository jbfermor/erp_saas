class SubdomainRequired
  def self.matches?(request)
    sub = request.subdomain

    return false if sub.blank?        # dominio sin subdominio
    return false if sub == "www"      # ignorar www
    return false if request.host == "localhost"  # localhost puro

    true
  end
end
