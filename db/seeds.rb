# db/seeds.rb
# =========================================================
# 🚀 SEED DE INICIALIZACIÓN DEL ERP SAAS
# =========================================================
# Crea:
#  1. Módulos base en castellano
#  2. Plan global para la cuenta madre
#  3. Cuenta madre (tenant principal)
#  4. Usuario propietario del SaaS (saas_owner)
# =========================================================

puts "🧩 Cargando módulos base del SaaS..."

base_modules = [
  { key: "saas",       name: "Gestión del SaaS",       description: "Administración de tenants, planes y suscripciones" },
  { key: "core",       name: "Núcleo",                 description: "Funciones base del sistema" },
  { key: "billing",    name: "Facturación",            description: "Gestión de cobros, pagos y facturas" },
  { key: "inventory",  name: "Inventario",             description: "Gestión de inventarios, existencias y movimientos" },
  { key: "sales",      name: "Ventas",                 description: "Gestión de clientes, pedidos y albaranes de venta" },
  { key: "purchases",  name: "Compras",                description: "Gestión de proveedores, pedidos y albaranes de compra" },
  { key: "crm",        name: "CRM",                    description: "Gestión de relaciones con clientes" },
  { key: "hr",         name: "Recursos Humanos",       description: "Gestión de personal, empleados y nóminas" },
  { key: "analytics",  name: "Analítica",              description: "Reportes, estadísticas e indicadores del sistema" }
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

global_plan = Saas::Plan.find_or_create_by!(code: "global") do |plan|
  plan.name = "Plan Global"
  plan.description = "Incluye todos los módulos disponibles del sistema"
end

# Asociar TODOS los módulos al plan global
Saas::Module.find_each do |mod|
  global_plan.modules << mod unless global_plan.modules.exists?(mod.id)
end

puts "✅ Plan global actualizado con #{global_plan.modules.count} módulos."

# =========================================================
# 👑 USUARIO SAAS OWNER
# =========================================================

puts "👑 Creando usuario propietario del SaaS..."

saas_owner_role = Saas::Role.find_or_create_by!(key: "saas_owner") do |r|
  r.name = "Propietario del SaaS"
  r.description = "Usuario con control total sobre el sistema, solo accesible desde la cuenta madre."
end

saas_owner_user = User.find_or_create_by!(email: "owner@saas.local") do |u|
  u.name = "SaaS Owner"
  u.password = "ChangeMe123!"
  u.password_confirmation = "ChangeMe123!"
  u.confirmed_at = Time.current if u.respond_to?(:confirmed_at)
end

puts "✅ Usuario SaaS Owner creado: #{saas_owner_user.email}"

# =========================================================
# 🏠 CUENTA MADRE DEL SISTEMA
# =========================================================

puts "🏠 Creando cuenta madre (tenant principal)..."

mother_account = Saas::Account.find_or_create_by!(slug: "main") do |acc|
  acc.name = "Cuenta Madre del SaaS"
  acc.subdomain = "saas"
  acc.database_name = "erp_saas_main"
  acc.plan = global_plan
  acc.owner = saas_owner_user
  acc.status = "active"
  acc.metadata = { system: true, created_by: "seed" }
end

puts "✅ Cuenta madre creada: #{mother_account.name} (plan: #{mother_account.plan.name}, owner: #{mother_account.owner.email})"

# =========================================================
# 🧱 PROVISIONADO DE BASE DE DATOS DEL TENANT MADRE
# =========================================================

begin
  db_exists = ActiveRecord::Base.connection.execute("SELECT 1 FROM pg_database WHERE datname='#{mother_account.database_name}'").any?
  unless db_exists
    ActiveRecord::Base.connection.create_database(mother_account.database_name)
    puts "📦 Base de datos creada para la cuenta madre: #{mother_account.database_name}"
  else
    puts "ℹ️ Base de datos ya existente: #{mother_account.database_name}"
  end
rescue => e
  puts "⚠️ Error creando base de datos del tenant madre: #{e.message}"
end

puts "🎉 Seed de inicialización completado."
