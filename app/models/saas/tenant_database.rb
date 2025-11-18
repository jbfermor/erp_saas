# app/models/saas/tenant_database.rb
module Saas
  class TenantDatabase < ApplicationRecord
    belongs_to :saas_account, class_name: "Saas::Account"

    validates :database_name, :username, :password, :host, :port, presence: true
    validates :database_name, uniqueness: { scope: :host }

    encrypts :password

    # Construye la URL de conexión para PostgreSQL
    def connection_url
      "postgresql://#{username}:#{password}@#{host}:#{port}/#{database_name}"
    end
  end
end
