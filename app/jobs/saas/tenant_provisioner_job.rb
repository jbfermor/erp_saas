module Saas
  class TenantProvisionerJob < ApplicationJob
    queue_as :default

    # Ejecuta el aprovisionamiento completo del tenant
    # account_id: ID de la Saas::Account recién creada
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

      # 1️⃣ Crear la base de datos física (si no existe)
      create_tenant_database(db_name, db_user, db_host, db_port)

      # 2️⃣ Ejecutar migraciones y seeds
      run_migrations_and_seeds(db_name, db_user, db_pass, db_host)

      # 3️⃣ Crear la company principal dentro de la base del tenant
      create_company_in_tenant(account, db_name, db_user, db_pass, db_host)

      # 4️⃣ Crear suscripciones según el plan contratado
      create_plan_subscriptions(account, db_name, db_user, db_pass, db_host)

      Rails.logger.info("✅ Tenant #{account.slug} aprovisionado correctamente.")
    rescue => e
      Rails.logger.error("❌ Error al aprovisionar tenant #{account_id}: #{e.message}")
      raise e
    end

    private

    # --------------------------------------------------
    # 1️⃣ Crear la base de datos física
    # --------------------------------------------------
    def create_tenant_database(db_name, db_user, db_host, db_port)
      Rails.logger.info("📦 Creando base de datos #{db_name}...")
      system("createdb -h #{db_host} -p #{db_port} -U #{db_user} #{db_name}")
    end

    # --------------------------------------------------
    # 2️⃣ Ejecutar migraciones y seeds
    # --------------------------------------------------
    def run_migrations_and_seeds(db_name, db_user, db_pass, db_host)
      Rails.logger.info("📜 Ejecutando migraciones y seeds para #{db_name}...")

      env = Rails.env
      base_url = "postgres://#{db_user}:#{db_pass}@#{db_host}/#{db_name}"

      # Cargar schema y luego los seeds base
      system("RAILS_ENV=#{env} DATABASE_URL=#{base_url} bin/rails db:schema:load")

      # after schema load + tenant seeds
      # Seed master data into tenant
      begin
        MasterData::Seeder.new(account).seed!
      rescue => e
        Rails.logger.error("Error replicando master_data para account #{account.id}: #{e.message}")
        raise
      end
    end

    # --------------------------------------------------
    # 3️⃣ Crear la company dentro del tenant
    # --------------------------------------------------
    def create_company_in_tenant(account, db_name, db_user, db_pass, db_host)
      Rails.logger.info("🏢 Creando company dentro del tenant #{account.slug}...")

      base_url = "postgres://#{db_user}:#{db_pass}@#{db_host}/#{db_name}"

      # Ejecutamos código dentro del contexto de la nueva base
      ActiveRecord::Base.connected_to(database: { writing: base_url }) do
        Core::Company.create!(
          name: account.name,
          slug: "#{account.slug}-company",
          status: "active"
        )
      end
    end

    # --------------------------------------------------
    # 4️⃣ Crear suscripciones según el plan contratado
    # --------------------------------------------------
    def create_plan_subscriptions(account, db_name, db_user, db_pass, db_host)
      plan = account.plan
      return unless plan

      base_url = "postgres://#{db_user}:#{db_pass}@#{db_host}/#{db_name}"

      ActiveRecord::Base.connected_to(database: { writing: base_url }) do
        company = Core::Company.first
        plan.modules.each do |mod|
          Core::Subscription.create!(
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
