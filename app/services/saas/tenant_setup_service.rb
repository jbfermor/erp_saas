# app/services/saas/tenant_setup_service.rb
module Saas
  class TenantSetupService
    attr_reader :tenant_database_data, :saas_account, :company_data,
                :owner_email, :owner_name, :owner_password

    def initialize(tenant_database_data:, saas_account:, company_data:, owner_email:, owner_name: nil, owner_password: "changeme")
      @tenant_database_data = tenant_database_data
      @saas_account = saas_account
      @company_data = company_data
      @owner_email = owner_email
      @owner_name = owner_name || owner_email.split("@").first
      @owner_password = owner_password
    end

    def call
      migrate_schema!
      switch_to_tenant_connection!
      seed_master_data!
      setup_company_and_owner!
      puts "✅ Tenant #{saas_account.slug} inicializado correctamente."
    rescue => e
      puts "❌ Error inicializando tenant #{saas_account.slug}: #{e.message}"
      raise e
    ensure
      base_cfg = Rails.configuration.database_configuration[Rails.env]
      base_cfg = base_cfg["primary"] if base_cfg.is_a?(Hash) && base_cfg.key?("primary")

      ActiveRecord::Base.establish_connection(base_cfg)    
    end

    private


    # -------------------------------
    # 1️⃣ Migraciones
    # -------------------------------
    def migrate_schema!
      puts "⚙️ Ejecutando migraciones para tenant #{saas_account.slug}..."

      ActiveRecord::Base.establish_connection(tenant_database_data)

      require "active_record/tasks/database_tasks"
      ActiveRecord::Tasks::DatabaseTasks.migrate
      ActiveRecord::Tasks::DatabaseTasks.migrations_paths = [
        Rails.root.join("db/tenants/core"),
        Rails.root.join("db/tenants/master_data"),
        Rails.root.join("db/tenants/modules")
      ]

  ActiveRecord::Tasks::DatabaseTasks.migrate

      puts "✅ Migraciones completadas."
    end

    # -------------------------------
    # 2️⃣ Cambiar conexión para seeds
    # -------------------------------
    def switch_to_tenant_connection!
      puts "🔌 Cambiando conexión al tenant..."
      ActiveRecord::Base.establish_connection(tenant_database_data)
      puts "🔌 Conectado a la base de datos tenant."
    end

    # -------------------------------
    # 3️⃣ Seeds master_data
    # -------------------------------
    def seed_master_data!
      puts "🌱 Ejecutando seeds de master_data internos..."

      Dir[Rails.root.join("db/seeds/master_data/**/*.rb")].sort.each do |file|
        puts "📦 Ejecutando #{File.basename(file)}"
        load file
      end

      puts "✅ Seeds master_data completados."
    end

    # -------------------------------
    # 4️⃣ Crear Company → Entity → Owner User
    # -------------------------------
    def setup_company_and_owner!
      puts "🏗 Creando estructura principal del tenant..."

      company = Core::Company.find_or_create_by!(name: company_data[:name]) do |c|
        c.name = company_data[:name]
        c.slug = company_data[:slug]
        c.saas_account_id = saas_account.id
      end
      puts "🏢 Company creada: #{company.name}"

      entity = Core::Entity.create!(
        company: company,
        entity_type: MasterData::EntityType.find_by!(slug: "individual")
      )

      user = Core::User.find_or_create_by!(email: owner_email) do |u|
        u.entity = entity
        u.company = company
        u.email = owner_email
        u.password = owner_password
        puts "🧑‍💼 Usuario principal creado: #{u.email}"
        u.password_confirmation = owner_password
        owner_role = MasterData::Role.find_by!(name: "Owner")
        ur = Core::UserRole.create!(user: u, role: owner_role, company: company)
        puts "🔐 Rol asignado: #{ur.role.name}"
      end

      plan = MasterData::Plan.find_or_create_by!(name: "Global Plan") do |p|
        p.name = "Global Plan"
        p.slug = "global_plan"
        p.description = "Plan global con todos los módulos"
      end

      MasterData::Module.find_each do |mod|
        plan.master_data_modules << mod unless plan.master_data_modules.exists?(mod.id)
      end

      plan.master_data_modules.each do |m|
        subscription = Core::Subscription.create!(
          company: company,
          module: m,
          active: true
        )
      end
      puts "📦 Suscripción creada para el plan: #{plan.name}"

      puts "✅ Estructura principal del tenant creada correctamente."
    end
  end
end
