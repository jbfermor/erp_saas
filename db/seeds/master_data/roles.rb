# db/seeds/saas/roles.rb

role_data = [
  { name: "Saas_owner", slug: "saas_owner", scope: "saas", position: 0, description: "Usuario con control total sobre el sistema, solo accesible desde la cuenta madre." },
  { name: "Saas_admin", slug: "saas_admin", scope: "saas", position: 1, description: "Usuario con control total sobre el sistema, excepto modificar el saas_owner, solo accesible desde la cuenta madre." },
  { name: "Owner", slug: "owner", scope: "tenant", position: 2,  description: "Usuario con control total sobre la entidad." },
  { name: "Admin", slug: "admin", scope: "tenant", position: 3, description: "Usuario con permisos administrativos." },
  { name: "Staff", slug: "staff", scope: "tenant", position: 4, description: "Usuario con permisos limitados para tareas diarias." },
  { name: "Customer", slug: "customer", scope: "tenant", position: 5, description: "Usuario cliente con acceso a su información y pedidos." }
]

role_data.each do |role_attrs|
  Saas::Role.find_or_create_by!(slug: role_attrs[:slug]) do |role|
    role.name = role_attrs[:name]
  end
end

puts "Se han creado los roles: #{Saas::Role.pluck(:name).join(', ')}"
