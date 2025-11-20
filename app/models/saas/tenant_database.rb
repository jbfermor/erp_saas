# app/models/saas/tenant_database.rb
module Saas
  class TenantDatabase < ApplicationRecord
    belongs_to :saas_account, class_name: "Saas::Account"

    validates :database_name, :username, :password, :host, :port, presence: true
    validates :database_name, uniqueness: { scope: :host }

    # encrypts :password

    def connection_url
      "postgresql://#{username}:#{password}@#{host}:#{port}/#{database_name}"
    end

    def connection_hash
      {
        adapter: "postgresql",
        host: host,
        port: port,
        database: database_name,
        username: username,
        password: password,
        encoding: "unicode",
        pool: 5
      }
    end
  end
end
