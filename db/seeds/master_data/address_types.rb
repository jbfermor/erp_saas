puts "🌍 Cargando tipos de dirección..."

address_type_data = [
  { name: "Personal", slug: "personal" },
  { name: "Laboral", slug: "work" },
  { name: "Envío", slug: "send" },
]

address_type_data.each do |a_attrs|
  MasterData::AddressType.find_or_create_by!(slug: a_attrs[:slug]) do |a|
    a.name = a_attrs[:name]
    a.slug = a_attrs[:slug]
  end
end

puts "Se han creado los tipos de dirección: #{MasterData::AddressType.pluck(:name).join(', ')}"