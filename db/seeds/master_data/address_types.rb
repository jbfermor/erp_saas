puts "🌍 Cargando tipos de dirección..."

address_type_data = [
  { name: "Personal", code: "personal", slug: "personal" },
  { name: "Laboral", code: "work", slug: "work" },
  { name: "Envío", code: "send", slug: "send" },
]

address_type_data.each do |a_attrs|
  MasterData::AddressType.find_or_create_by!(slug: a_attrs[:slug]) do |a|
    a.name = a_attrs[:name]
    a.code = a_attrs[:code]
    a.slug = a_attrs[:slug]
  end
end

puts "Se han creado los tipos de dirección: #{MasterData::AddressType.pluck(:name).join(', ')}"