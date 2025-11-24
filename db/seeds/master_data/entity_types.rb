puts "🌍 Cargando tipos de idendidad..."

entity_type_data = [
  { name: "Persona fisica", slug: "individual" },
  { name: "Persona jurídica", slug: "bussiness" },
]

entity_type_data.each do |et_attrs|
  MasterData::EntityType.find_or_create_by!(slug: et_attrs[:slug]) do |et|
    et.name = et_attrs[:name]
    et.slug = et_attrs[:slug]
  end
end

puts "Se han creado los tipos de identidad: #{MasterData::EntityType.pluck(:name).join(', ')}"