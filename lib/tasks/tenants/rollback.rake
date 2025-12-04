namespace :db do
  namespace :rollback do
    desc "Rollback migrations for a specific tenant"
    task :tenant => :environment do
      tenant_slug = ENV["TENANT"]
      step        = ENV["STEP"]&.to_i || 1

      unless tenant_slug
        puts "❌ Debes indicar TENANT="
        exit 1
      end

      puts "🔧 Revirtiendo migraciones del tenant: #{tenant_slug}"

      # 1. Obtener configuración de la BD del tenant
      sa = Saas::Account.find_by!(slug: tenant_slug)
      tdb = Saas::TenantDatabase.find_by!(saas_account_id: sa.id)
      cfg = tdb.connection_hash.deep_symbolize_keys

      # 2. Conectar al tenant
      puts "🔌 Conectando con la BD del tenant..."
      ActiveRecord::Base.establish_connection(cfg)

      # 3. Cargar migraciones desde carpetas tenant
      migration_paths = [
        Rails.root.join("db/migrate").to_s,
        Rails.root.join("db/tenants/core").to_s,
        Rails.root.join("db/tenants/master_data").to_s,
        Rails.root.join("db/tenants/modules").to_s
      ]

      context = ActiveRecord::MigrationContext.new(migration_paths)

      # 4. Ejecutar rollback
      puts "⏪ Ejecutando rollback STEP=#{step}..."
      context.rollback(step)

      puts "✅ Rollback completado para #{tenant_slug}"

    rescue => e
      puts "❌ Error realizando rollback del tenant #{tenant_slug}: #{e.class}: #{e.message}"
      raise e
    ensure
      # 5. Volver a la BD primaria del sistema
      base_cfg = Rails.configuration.database_configuration[Rails.env]
      base_cfg = base_cfg["primary"] if base_cfg.is_a?(Hash) && base_cfg.key?("primary")
      ActiveRecord::Base.establish_connection(base_cfg)
      puts "🔁 Conexión restaurada a la BD principal."
    end
  end
end
