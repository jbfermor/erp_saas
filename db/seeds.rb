# =========================================================
# 🚀 SEED DE INICIALIZACIÓN DEL ERP SAAS
# =========================================================

puts "=============================================="
puts "🚀 INICIALIZANDO ERP SAAS"
puts "=============================================="

# ---------------------------------------------------------
# 🔌 1️⃣ Conectarse manualmente a la base principal (erp_saas)
# ---------------------------------------------------------
puts "🔌 Conectando a base principal (erp_saas)..."

begin
  # Establecemos la conexión principal
  ActiveRecord::Base.establish_connection(:development)
  puts "✅ Conexión establecida correctamente."

  # Migrar usando la API soportada en Rails 8
  require "active_record/tasks/database_tasks"

  puts "⚙️ Comprobando y ejecutando migraciones (Rails 8)..."
  puts "BD usada por AddressType: #{MasterData::AddressType.connection_db_config.database}"

  ActiveRecord::Tasks::DatabaseTasks.env = Rails.env
  ActiveRecord::Tasks::DatabaseTasks.db_dir = Rails.root.join("db")
  ActiveRecord::Tasks::DatabaseTasks.migrations_paths = [Rails.root.join("db/migrate")]
  ActiveRecord::Tasks::DatabaseTasks.database_configuration = Rails.configuration.database_configuration

  ActiveRecord::Tasks::DatabaseTasks.migrate

  # ---------------------------------------------------------
  # 🌱 2️⃣ Cargar seeds secundarios (master_data)
  # ---------------------------------------------------------
  puts "🌱 Cargando seeds de master_data..."
  master_data_path = Rails.root.join("db", "seeds", "master_data", "*.rb")

  Dir[master_data_path].sort.each do |file|
    seed_name = File.basename(file, ".rb")
    puts "   → Ejecutando #{seed_name}..."
    begin
      load file
    rescue => e
      puts "   ❌ Error al cargar #{seed_name}: #{e.message}"
    end
  end

  puts "✅ Seeds de master_data cargados correctamente."

rescue => e
  puts "❌ Error al conectar o migrar la base principal: #{e.message}"
  puts e.backtrace.first(10)
  raise e
end

# ---------------------------------------------------------
# 🧩 3️⃣ Crear la cuenta madre (account principal)
# ---------------------------------------------------------
puts "🏗 Creando cuenta madre (SaaS Master)..."

begin
  global_plan = Saas::Plan.find_or_create_by!(key: "saas") do |plan|
    plan.name = "Core SaaS Plan"
    plan.description = "Incluye todos los módulos base del sistema"
  end

  base_modules = [
    { key: "saas", name: "Gestión del SaaS", description: "Administración de tenants, planes y suscripciones" },
    { key: "core", name: "Núcleo", description: "Funciones base del sistema" }
  ]

  base_modules.each do |mod|
    Saas::Module.find_or_create_by!(key: mod[:key]) do |m|
      m.name = mod[:name]
      m.description = mod[:description]
      m.active = true
    end
  end

  Saas::Module.find_each do |mod|
    global_plan.modules << mod unless global_plan.modules.exists?(mod.id)
  end

  mother_account = Saas::Account.find_or_create_by!(slug: "master") do |acc|
    acc.name = "SaaS Master"
    acc.subdomain = "master"
    acc.database_name = "master"
    acc.plan = global_plan
  end

  puts "✅ Cuenta madre creada o existente: #{mother_account.name} (DB: #{mother_account.database_name})"
rescue => e
  puts "❌ Error creando la cuenta madre: #{e.message}"
  raise e
end

# ---------------------------------------------------------
# 🏁 4️⃣ Resumen final
# ---------------------------------------------------------
puts "=============================================="
puts "🎉 Seed completado correctamente"
puts "   ▫ Base principal: erp_saas"
puts "   ▫ Account madre: SaaS Master (DB: master)"
puts "=============================================="
