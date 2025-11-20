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
      ActiveRecord::Base.establish_connection(Rails.configuration.database_configuration[Rails.env])
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

      company = Core::Company.create!(
        name: company_data[:name],
        slug: company_data[:slug],
        saas_account_id: saas_account.id
      )
      puts "🏢 Company creada: #{company.name}"

      entity = Core::Entity.create!(
        company: company,
        entity_type: MasterData::EntityType.find_by!(code: "individual")
      )

      user = Core::User.create!(
        entity: entity,
        company: company,
        email: owner_email,
        password: owner_password,
        password_confirmation: owner_password
      )
      puts "🧑‍💼 Usuario principal creado: #{user.email}"

      owner_role = MasterData::Role.find_by!(name: "Owner")
      ur = Core::UserRole.create!(user: user, role: owner_role, company: company)

      puts "🔐 Rol asignado: #{ur.role.name}"
    end
  end
end
