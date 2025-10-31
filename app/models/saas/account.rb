module Saas
  class Account < ApplicationRecord
    belongs_to :plan, class_name: "Saas::Plan"

    validates :name, :slug, :subdomain, :database_name, presence: true
    validates :slug, :subdomain, :database_name, uniqueness: true

    delegate :modules, to: :plan

    scope :active, -> { where(status: "active") }

    # Determina si esta es la cuenta madre del SaaS
    def mother_account?
      slug == "main" || subdomain == "saas"
    end

    # Helper para crear el tenant DB
    def provision_database!
      db_name = database_name
      return if ActiveRecord::Base.connection.execute("SELECT datname FROM pg_database WHERE datname='#{db_name}'").any?

      ActiveRecord::Base.connection.create_database(db_name)
      puts "✅ Created tenant database: #{db_name}"
    end

    # Helper para eliminar la DB del tenant
    def drop_database!
      ActiveRecord::Base.connection.drop_database(database_name)
      puts "🗑️ Dropped tenant database: #{database_name}"
    end
  end
end
