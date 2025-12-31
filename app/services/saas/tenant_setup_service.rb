# frozen_string_literal: true

module Saas
  class TenantSetupService
    attr_reader :tenant_database_data, :saas_account, :company_data,
                :owner_email, :owner_name, :owner_password, :plan

    def initialize(tenant_database_data:, saas_account:, company_data:,
                   owner_email:, owner_name: nil, owner_password: "changeme", plan: nil)
      @tenant_database_data = tenant_database_data.deep_symbolize_keys
      @saas_account         = saas_account
      @company_data         = company_data
      @owner_email          = owner_email
      @owner_name           = owner_name || owner_email.split("@").first
      @owner_password       = owner_password
      @plan                 = plan
    end

    # ============================================================
    # ENTRY POINT
    # ============================================================
    def call
      puts "⚙️ Ejecutando setup tenant: #{saas_account.slug}"

      migrate_schema!
      switch_to_tenant_connection!
      seed_master_data!
      company = setup_company_and_owner!
      seed_database_config_for_company!(company)

      puts "✅ Tenant #{saas_account.slug} inicializado correctamente."
      company
    rescue => e
      puts "❌ Error inicializando tenant #{saas_account.slug}: #{e.class}: #{e.message}"
      raise
    ensure
      restore_primary_connection!
    end

    private

    # ============================================================
    # 1️⃣ MIGRACIONES DEL TENANT
    # ============================================================
    def migrate_schema!
      puts "⚙️ Ejecutando migraciones para tenant #{saas_account.slug}..."

      ActiveRecord::Base.establish_connection(tenant_database_data)
      conn = ActiveRecord::Base.connection

      migration_paths = [
        Rails.root.join("db/migrate/tenants/master_data").to_s,
        Rails.root.join("db/migrate/tenants/core").to_s,
        Rails.root.join("db/migrate/tenants/contact").to_s
      ].freeze

      migration_paths.each do |path|
        if Dir.exist?(path)
          puts "Migraciones en #{path}:"
          Dir["#{path}/*.rb"].sort.each { |f| puts " - #{File.basename(f)}" }
        else
          puts "Ruta de migraciones no existe (se ignora): #{path}"
        end
      end

      existing_tables = conn.tables - %w[schema_migrations ar_internal_metadata]

      if existing_tables.any?
        puts "⚠️ Tablas existentes detectadas: #{existing_tables.join(', ')}"

        if Rails.env.production?
          raise "Abortando: la BD del tenant no está vacía."
        end

        unless ENV["TENANT_AUTO_CLEAN"] == "1"
          raise "La BD tenant no está vacía. Usa TENANT_AUTO_CLEAN=1 en desarrollo."
        end

        puts "🧹 Auto-limpieza activada — reseteando schema completo..."

        conn.execute("DROP SCHEMA public CASCADE;")
        conn.execute("CREATE SCHEMA public;")

        ensure_schema_migrations_table!(conn)
        ensure_ar_internal_metadata!(conn)

        puts "🧨 Schema reiniciado correctamente."
      end

      context = ActiveRecord::MigrationContext.new(migration_paths)
      context.migrate

      puts "✅ Migraciones completadas para tenant #{saas_account.slug}."
    end

    # ============================================================
    # 2️⃣ CAMBIO DE CONEXIÓN
    # ============================================================
    def switch_to_tenant_connection!
      puts "🔌 Cambiando conexión al tenant..."

      ActiveRecord::Base.connection_handler.clear_all_connections!
      ActiveRecord::Base.establish_connection(tenant_database_data)

      puts "   🗄  Base actual: #{ActiveRecord::Base.connection.current_database}"
    end

    # ============================================================
    # 3️⃣ SEEDS
    # ============================================================
    def seed_master_data!
      puts "🌱 Ejecutando seeds de master_data..."

      required_tables = %w[
        master_data_roles
        master_data_entity_types
        master_data_address_types
      ]

      missing = required_tables.reject do |t|
        ActiveRecord::Base.connection.table_exists?(t)
      end

      raise "❌ Faltan tablas críticas: #{missing.join(', ')}" if missing.any?

      Dir[Rails.root.join("db/seeds/master_data/**/*.rb")].sort.each do |file|
        puts "📦 Ejecutando #{File.basename(file)}"
        load file
      end

      Dir[Rails.root.join("db/seeds/contact/**/*.rb")].sort.each do |file|
        puts "📦 Ejecutando #{File.basename(file)}"
        load file
      end

      puts "✅ Seeds master_data completados."
    end

    # ============================================================
    # 4️⃣ COMPANY, ENTITY Y USUARIOS
    # ============================================================
    def setup_company_and_owner!
      puts "🏗 Creando estructura principal del tenant..."

      company = Core::Company.find_or_create_by!(name: company_data[:name]) do |c|
        c.slug = company_data[:slug]
        c.saas_account_id = saas_account.id
      end

      company_entity = Core::Entity.create!(
        company: company,
        entity_type: MasterData::EntityType.find_by!(slug: "system")
      )

      user_entity = Core::Entity.create!(
        company: company,
        entity_type: MasterData::EntityType.find_by!(slug: "individual")
      )

      user = Core::User.find_or_create_by!(email: owner_email) do |u|
        u.role = MasterData::Role.find_by!(slug: "owner")
        u.company = company
        u.entity = user_entity
        u.password = owner_password
        u.password_confirmation = owner_password
      end

      create_system_user(company)
      asign_plan_to_company(company)

      puts "✅ Estructura principal creada."
      company
    end

    def create_system_user(company)
      entity = Core::Entity.create!(
        company: company,
        entity_type: MasterData::EntityType.find_by!(slug: "system")
      )

      Core::User.find_or_create_by!(email: "system@saas.com") do |u|
        u.role = MasterData::Role.find_by!(slug: "saas_admin")
        u.company = company
        u.entity = entity
        u.password = "systempassword"
        u.password_confirmation = "systempassword"
      end
    end

    # ============================================================
    # 5️⃣ DATABASE CONFIG
    # ============================================================
    def seed_database_config_for_company!(company)
      MasterData::DatabaseConfig.find_or_create_by!(company: company) do |cfg|
        cfg.host          = tenant_database_data[:host]
        cfg.port          = tenant_database_data[:port] || 5432
        cfg.database_name = tenant_database_data[:database]
        cfg.username      = tenant_database_data[:username]
        cfg.password      = tenant_database_data[:password]
      end
    end

    # ============================================================
    # HELPERS
    # ============================================================
    def restore_primary_connection!
      base_cfg = Rails.configuration.database_configuration[Rails.env]
      base_cfg = base_cfg["primary"] if base_cfg.is_a?(Hash) && base_cfg["primary"]

      ActiveRecord::Base.establish_connection(base_cfg)
      puts "🔁 Restaurada conexión principal."
    end

    def ensure_schema_migrations_table!(conn)
      return if conn.table_exists?("schema_migrations")

      conn.create_table("schema_migrations", id: false) do |t|
        t.string :version, null: false
      end

      conn.add_index "schema_migrations", :version, unique: true
    end

    def ensure_ar_internal_metadata!(conn)
      return if conn.table_exists?("ar_internal_metadata")

      conn.create_table("ar_internal_metadata") do |t|
        t.string :key, null: false
        t.string :value
        t.timestamps
      end

      conn.add_index "ar_internal_metadata", :key, unique: true
    end

    def asign_plan_to_company(company)
      plan = MasterData::Plan.find_or_create_by!(
        name: "Global Plan"
        ) do |p|
          p.slug = "global_plan"
          p.description = "Plan global con todos los módulos"
        end

      MasterData::Module.find_each do |mod|
        plan.modules << mod unless plan.modules.exists?(mod.id)
      end

      Core::CompanyPlan.find_or_create_by!(
        company: company,
        plan: plan, 
        active: true
        ) do |cp|
          puts "🏗 Asignando plan #{plan.name} a la compañía #{company.name}"
          cp.company = company
          cp.plan = plan
          cp.active = true
        end    
    end
  end
end
