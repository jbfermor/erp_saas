# =========================================================
# 🚀 SEED DE INICIALIZACIÓN DEL ERP SAAS
# =========================================================
# Este seed:
#  1. Carga los módulos base del SaaS
#  2. Crea el plan global para la cuenta madre
#  3. Carga datos fijos (entidades, tipos de documento, etc.)
#  4. Crea la cuenta madre (account principal)
#  5. Lanza un Job en background que crea la base de datos
#     del tenant, su company, y sus suscripciones
# =========================================================

puts "🧩 Cargando módulos base del SaaS..."

base_modules = [
  { key: "saas", name: "Gestión del SaaS", description: "Administración de tenants, planes y suscripciones" },
  { key: "core", name: "Núcleo", description: "Funciones base del sistema" },
  { key: "billing", name: "Facturación", description: "Gestión de cobros, pagos y facturas" },
  { key: "inventory", name: "Inventario", description: "Gestión de existencias y movimientos" },
  { key: "sales", name: "Ventas", description: "Gestión de clientes, pedidos y albaranes de venta" },
  { key: "purchases", name: "Compras", description: "Gestión de proveedores y compras" },
  { key: "crm", name: "CRM", description: "Relaciones con clientes" },
  { key: "hr", name: "Recursos Humanos", description: "Empleados y nóminas" },
  { key: "analytics", name: "Analítica", description: "Reportes e indicadores" }
]

base_modules.each do |mod|
  Saas::Module.find_or_create_by!(key: mod[:key]) do |m|
    m.name = mod[:name]
    m.description = mod[:description]
    m.active = true
  end
end

puts "✅ Módulos base cargados: #{Saas::Module.count}"

# =========================================================
# 🧠 PLAN GLOBAL (para la cuenta madre)
# =========================================================

puts "🌍 Creando o actualizando plan global..."

global_plan = Saas::Plan.find_or_create_by!(code: "saas") do |plan|
  plan.name = "Core Saas Plan"
  plan.description = "Incluye todos los módulos disponibles del sistema"
end

Saas::Module.find_each do |mod|
  global_plan.modules << mod unless global_plan.modules.exists?(mod.id)
end

puts "✅ Plan global actualizado con #{global_plan.modules.count} módulos."

# =========================================================
# 📦 CARGAR SEEDS SECUNDARIOS (países, roles, etc.)
# =========================================================

Dir[Rails.root.join("db/seeds/**/*.rb")].sort.each do |file|
  next if file.end_with?("seeds.rb") # evitar recursión
  puts "📦 Ejecutando seed: #{File.basename(file)}"
  load file
end

puts "✅ Seeds secundarios cargados correctamente."

# =========================================================
# 🏗 CREAR CUENTA MADRE (solo si no existe)
# =========================================================

puts "🏗 Creando cuenta madre y preparando tenant..."

mother_account = Saas::Account.find_or_create_by!(slug: "saas-master") do |acc|
  acc.name = "SaaS Master"
  acc.subdomain = "master"
  acc.database_name = "erp_saas_master"
  acc.plan = global_plan
end

# Datos de conexión del tenant madre (solo desarrollo)
tenant_db_params = {
  host: ENV.fetch("PGHOST", "localhost"),
  port: ENV.fetch("PGPORT", 5432),
  username: ENV.fetch("PGUSER", "postgres"),
  password: ENV.fetch("PGPASSWORD", "postgres"),
  database_name: mother_account.database_name
}

mother_account.build_tenant_database(tenant_db_params)
mother_account.save!

# =========================================================
# ⚙️ LANZAR JOB DE PROVISIONAMIENTO
# =========================================================

if Saas::TenantDatabase.exists?(account: mother_account)
  puts "🕓 Encolando TenantProvisionerJob para la cuenta madre..."
  Saas::TenantProvisionerJob.perform_later(mother_account.id)
else
  puts "⚠️ No se pudo crear TenantDatabase para la cuenta madre."
end

puts "✅ Seed de inicialización completado correctamente."
