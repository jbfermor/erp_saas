puts "🌍 Cargando tipos de impuesto..."

entity_role_state_data = [
  { name: "active", slug: "active" },
  { name: "archived", slug: "archived" },
]

entity_role_state_data.each do |t_attrs|
  MasterData::EntityRoleAssignmentState.find_or_create_by!(slug: t_attrs[:slug]) do |t|
    t.name = t_attrs[:name]
    t.slug = t_attrs[:slug]
  end
end

puts "Se han creado los tipos de impuesto: #{MasterData::EntityRoleAssignmentState.pluck(:name).join(', ')}"