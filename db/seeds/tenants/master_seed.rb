# =========================================================
# 🌍 SEED DE INICIALIZACIÓN PARA EL TENANT MASTER
# =========================================================
# Este seed se ejecuta DENTRO de la base de datos "erp_saas_master"
# =========================================================

puts "🚀 Inicializando tenant master..."

# 1️⃣ Crear la company principal
company = Core::Company.find_or_create_by!(name: "SaaS Global") do |c|
  c.tax_id = "X0000000X"
  c.legal_name = "SaaS Global"
end
puts "🏢 Company creada: #{company.name}"

# 2️⃣ Crear una entity (persona física) asociada a la company
entity = Core::Entity.find_or_create_by!(name: "SaaS Owner") do |e|
  e.company = company
  e.entity_type = MasterData::EntityType.find_by!(key: "person")
end
puts "👤 Entity creada: #{entity.name}"

# 3️⃣ Crear un usuario principal (saas_owner)
user = Core::User.find_or_create_by!(email: "owner@saas.com") do |u|
  u.entity = entity
  u.password = "changeme"
  u.password_confirmation = "changeme"
  u.active = true
end
puts "🧑‍💼 Usuario principal creado: #{user.email}"

# 4️⃣ Asignar rol "saas_owner"
owner_role = MasterData::Role.find_by!(name: "SaaS Owner")
user.update!(role: owner_role)
puts "🔐 Rol asignado: #{owner_role.name}"

# 5️⃣ Ejecutar los seeds de master_data internos (roles, countries, etc)
Dir[Rails.root.join("db/seeds/master_data/**/*.rb")].sort.each do |file|
  puts "📦 Ejecutando master_data seed: #{File.basename(file)}"
  load file
end

puts "✅ Tenant master inicializado correctamente."
