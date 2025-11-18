module Saas
  class TenantProvisionerJob < ApplicationJob
    queue_as :default

    def perform(account_id)
      account = Saas::Account.find(account_id)
      tenant_db = account.tenant_database

      raise "Tenant database not found for Account ##{account.id}" unless tenant_db.present?

      db_name = tenant_db.database_name
      db_user = tenant_db.username
      db_pass = tenant_db.password
      db_host = tenant_db.host
      db_port = tenant_db.port || 5432

      Rails.logger.info("🚀 Iniciando provisión del tenant #{account.slug} (DB: #{db_name})")

      # 1️⃣ Verificar conexión
      verify_database_connection(db_name, db_user, db_pass, db_host, db_port)

      # 2️⃣ Ejecutar migraciones y seeds
      run_migrations_and_seeds(account, db_name, db_user, db_pass, db_host)

      # 3️⃣ Crear la company principal dentro del tenant
      create_company_in_tenant(account, db_name, db_user, db_pass, db_host)

      # 4️⃣ Crear suscripciones según el plan contratado
      create_plan_subscriptions(account, db_name, db_user, db_pass, db_host)

      Rails.logger.info("✅ Tenant #{account.slug} aprovisionado correctamente.")
    rescue => e
      Rails.logger.error("❌ Error al aprovisionar tenant #{account_id}: #{e.message}")
      raise e
    end

    private

    def verify_database_connection(db_name, db_user, db_pass, db_host, db_port)
      Rails.logger.info("🔍 Verificando conexión a la base de datos #{db_name}...")
      conn = PG.connect(host: db_host, port: db_port, user: db_user, password: db_pass, dbname: db_name)
      conn.close
      Rails.logger.info("✅ Conexión verificada correctamente.")
    rescue PG::Error => e
      raise "❌ No se pudo conectar a la base de datos #{db_name}: #{e.message}"
    end

    def run_migrations_and_seeds(account, db_name, db_user, db_pass, db_host)
      Rails.logger.info("📜 Ejecutando migraciones y seeds para #{db_name}...")

      env = Rails.env
      base_url = "postgres://#{db_user}:#{db_pass}@#{db_host}/#{db_name}"

      system("RAILS_ENV=#{env} DATABASE_URL=#{base_url} bin/rails db:schema:load")

      MasterData::Seeder.new(account).seed!
    end

    def create_company_in_tenant(account, db_name, db_user, db_pass, db_host)
      Rails.logger.info("🏢 Creando company dentro del tenant #{account.slug}...")

      base_url = "postgres://#{db_user}:#{db_pass}@#{db_host}/#{db_name}"

      ActiveRecord::Base.connected_to(database: { writing: base_url }) do
        Core::Company.find_or_create_by!(
          name: account.name,
          slug: "#{account.slug}-company",
          status: "active"
        )
      end
    end

    def create_plan_subscriptions(account, db_name, db_user, db_pass, db_host)
      plan = account.plan
      return unless plan

      base_url = "postgres://#{db_user}:#{db_pass}@#{db_host}/#{db_name}"

      ActiveRecord::Base.connected_to(database: { writing: base_url }) do
        company = Core::Company.first
        plan.modules.each do |mod|
          Core::Subscription.find_or_create_by!(
            company: company,
            module: mod,
            status: "active",
            starts_at: Time.current
          )
        end
      end
    end
  end
end
