# app/services/saas/tenant_setup_service.rb
module Saas
  class TenantSetupService
    attr_reader :tenant_database_data, :saas_account, :company_data,
                :owner_email, :owner_name, :owner_password, :plan

    def initialize(tenant_database_data:, saas_account:, company_data:, owner_email:, owner_name: nil, owner_password: "changeme", plan: nil)
      @tenant_database_data = tenant_database_data.deep_symbolize_keys
      @saas_account = saas_account
      @company_data = company_data
      @owner_email = owner_email
      @owner_name = owner_name || owner_email.split("@").first
      @owner_password = owner_password
      @plan = plan
    end

    # Entry point
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
      raise e
    ensure
      restore_primary_connection!
    end

    private

    # -------------------------------
# 1️⃣ Migraciones (Rails 8) - seguro: marca versiones ya aplicadas
# -------------------------------
def migrate_schema!
  puts "⚙️ Ejecutando migraciones para tenant #{saas_account.slug}..."

  # Conectamos al tenant (debe existir la DB ya)
  ActiveRecord::Base.establish_connection(tenant_database_data)
  conn = ActiveRecord::Base.connection

  migration_paths = [
    Rails.root.join("db/tenants/master_data").to_s,
    Rails.root.join("db/tenants/core").to_s,
    Rails.root.join("db/tenants/modules").to_s
  ].freeze

  # Debug: listar archivos detectados
  migration_paths.each do |path|
    if Dir.exist?(path)
      puts "Migraciones en #{path}:"
      Dir["#{path}/*.rb"].sort.each { |f| puts " - #{File.basename(f)}" }
    else
      puts "Ruta de migraciones no existe (se ignora): #{path}"
    end
  end

  # Asegurar schema_migrations en tenant
  ensure_schema_migrations_table!(conn)

  # -------------------------------------------------
  # PERFIL DE SEGURIDAD: comprobar tablas preexistentes
  # -------------------------------------------------
  existing = conn.tables - ["schema_migrations", "ar_internal_metadata"]
  if existing.any?
    puts "⚠️ Advertencia: se han detectado tablas preexistentes en la BD del tenant: #{existing.join(', ')}"

    # En production: abortamos (no tocamos DB automaticamente)
    if Rails.env.production?
      raise "Abortando migraciones del tenant #{saas_account.slug}: existen tablas preexistentes (#{existing.join(', ')}). Revisa seeds/migrators."
    end

    # En development/test: opción de limpieza automática (segura para dev)
    if Rails.env.development?
      # Si quieres autolimpiar sin preguntar (útil en CI/dev), cambia a true
      auto_clean = ENV['TENANT_AUTO_CLEAN'] == '1'
      if auto_clean
        puts "🧹 Auto-limpieza activada por TENANT_AUTO_CLEAN=1 — eliminando tablas existentes..."
        existing.each do |t|
          begin
            conn.drop_table(t, if_exists: true, force: :cascade)
            puts "   - tabla #{t} eliminada"
          rescue => e
            puts "   ! error al eliminar #{t}: #{e.message}"
            raise
          end
        end
        Rails.logger.info "🧨 Reiniciando schema tras clean..."

        ActiveRecord::Base.connection.execute("DROP SCHEMA public CASCADE;")
        ActiveRecord::Base.connection.execute("CREATE SCHEMA public;")

        Rails.logger.info "🧨 Schema reiniciado. Migraciones se ejecutarán desde cero."
      else
        raise "La BD tenant no está vacía. Si quieres forzar limpieza en dev exporta TENANT_AUTO_CLEAN=1 y reejecuta. Tablas detectadas: #{existing.join(', ')}"
      end
    end
  end

  # Finalmente ejecutar migraciones pendientes (Rails 8)
  context = ActiveRecord::MigrationContext.new(migration_paths)
  context.migrate

  puts "✅ Migraciones completadas para tenant #{saas_account.slug}."
end

    # ------------------------------------------------------------
    # 2️⃣ Cambiar conexión para seeds (se asume que la DB tenant existe)
    # ------------------------------------------------------------
    def switch_to_tenant_connection!
      puts "🔌 Cambiando conexión al tenant..."

      ActiveRecord::Base.connection_handler.clear_all_connections!

      ActiveRecord::Base.establish_connection(tenant_database_data)

      # Verificación REAL (clave)
      puts "   🗄  Base actual: #{ActiveRecord::Base.connection.current_database}"
    end


    # ------------------------------------------------------------
    # 3️⃣ Seeds master_data internos
    # ------------------------------------------------------------
    def seed_master_data!
      puts "🌱 Ejecutando seeds de master_data internos..."

      Dir[Rails.root.join("db/seeds/master_data/**/*.rb")].sort.each do |file|
        puts "📦 Ejecutando #{File.basename(file)}"
        load file
      end

      puts "✅ Seeds master_data completados."
    end

    # ------------------------------------------------------------
    # 4️⃣ Crear Company → Entity → Owner User
    # ------------------------------------------------------------
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
        u.role = MasterData::Role.find_by!(slug: "owner")
        u.entity = entity
        u.company = company
        u.email = owner_email
        u.password = owner_password
        u.password_confirmation = owner_password
      end

      puts "🧑‍💼 Usuario principal creado/recuperado: #{user.email}"

      puts "🔐 Rol Owner asignado a #{user.email}"

      # Crear usuario sistema
      create_system_user(company)

      puts "✅ Estructura principal del tenant creada correctamente."

      asign_plan_to_company(company, @plan) if @plan

      company
    end

    def asign_plan_to_company(company, plan)
      return unless plan

      company_plan = MasterData::CompanyPlan.find_or_create_by!(company: company) do |cp|
        cp.company = company
        cp.plan = plan
      end

      puts "📋 Plan asignado a la compañía: #{company_plan.plan.name}"
    end

    def create_system_user(company)
      entity = Core::Entity.create!(
        company: company,
        entity_type: MasterData::EntityType.find_by!(slug: "system")
      )

      user = Core::User.find_or_create_by!(email: "system@saas.com") do |u|
        u.role = MasterData::Role.find_by!(slug: "saas_admin")
        u.email = "system@saas.com"
        u.password = "systempassword"
        u.password_confirmation = "systempassword"
        u.company = company
        u.entity = entity
      end

      puts "🤖 Usuario sistema creado/recuperado: #{user.email}"
      user
    end

    # ------------------------------------------------------------
    # 5️⃣ Guardar MasterData::DatabaseConfig asociado a company
    # ------------------------------------------------------------
    def seed_database_config_for_company!(company)
      puts "🔐 Guardando MasterData::DatabaseConfig para la company #{company.name}..."

      # Normalización mínima (Rails puede dar host/database como string o symbol)
      host     = tenant_database_data[:host] || tenant_database_data["host"]
      port     = tenant_database_data[:port] || tenant_database_data["port"] || 5432
      database = tenant_database_data[:database] || tenant_database_data["database_name"] || tenant_database_data[:db_name]
      username = tenant_database_data[:username] || tenant_database_data["username"]
      password = tenant_database_data[:password] || tenant_database_data["password"]

      # Crear o actualizar el registro (vive en el tenant)
      config = MasterData::DatabaseConfig.find_or_create_by!(company: company) do |cfg|
        cfg.company = company
        cfg.host = host
        cfg.port = port
        cfg.database_name = database
        cfg.username = username
        cfg.password = password
      end

      puts "🔐 MasterData::DatabaseConfig guardado (company_id=#{company.id})."
      config
    end

    # -------------------------
    # Helpers y utilidades
    # -------------------------

    def restore_primary_connection!
      base_cfg = Rails.configuration.database_configuration[Rails.env]
      base_cfg = base_cfg["primary"] if base_cfg.is_a?(Hash) && base_cfg.key?("primary")
      ActiveRecord::Base.establish_connection(base_cfg)
      puts "🔁 Restaurada conexión principal (#{base_cfg['database'] || base_cfg[:database]})."
    rescue => e
      puts "⚠️ No se pudo restaurar conexión principal automáticamente: #{e.message}"
    end

    def ensure_schema_migrations_table!(conn)
      sm_table = "schema_migrations"
      unless conn.table_exists?(sm_table)
        puts "   🛠 Creando tabla #{sm_table} en tenant..."
        # crear la tabla schema_migrations si no existe (compatible con Postgres)
        conn.create_table(sm_table) do |t|
          t.string :version, null: false
        end
        # crear índice único sobre version (compatibilidad)
        conn.add_index(sm_table, :version, unique: true, name: "unique_schema_migrations")
      end
    end

    def schema_migration_version_exists?(version)
      ActiveRecord::Base.connection.execute("SELECT 1 FROM schema_migrations WHERE version = '#{version}' LIMIT 1").ntuples > 0
    end

    def insert_schema_migration_version(conn, version)
      # Inserta con ON CONFLICT DO NOTHING (Postgres)
      conn.execute <<~SQL
        INSERT INTO schema_migrations (version) VALUES ('#{version}')
        ON CONFLICT (version) DO NOTHING;
      SQL
    end

    # Heurística simple: parsear archivos de migración en busca de create_table :name
    def extract_tables_from_migration_file(file_path)
      content = File.read(file_path)
      tables = content.scan(/create_table\s+:([a-zA-Z0-9_]+)/).flatten.map(&:to_s)
      tables.uniq
    rescue => e
      puts "   ⚠️ No se pudo parsear migration #{file_path}: #{e.message}"
      []
    end
  end
end
