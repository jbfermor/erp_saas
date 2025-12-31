puts "🌍 Cargando roles de entidades del sistema..."

entity_role_data = [
  { name: "Proveedora", slug: "supplier"},
  { name: "Clienta", slug: "customer"},
  { name: "Persona de contacto", slug: "contact_person" },
  { name: "Trabajadora", slug: "worker" },
]

entity_role_data.each do |a_attrs|
  Contact::EntityRole.find_or_create_by!(slug: a_attrs[:slug]) do |a|
    a.name = a_attrs[:name]
    a.slug = a_attrs[:slug]
    a.system = true
  end
end

puts "Se han creado los roles de entidades: #{Contact::EntityRole.pluck(:name).join(', ')}"