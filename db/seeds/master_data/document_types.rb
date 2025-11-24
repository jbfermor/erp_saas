puts "🌍 Cargando tipos de documento de idendidad..."

document_type_data = [
  { name: "DNI", slug: "dni" },
  { name: "NIE", slug: "nie" },
  { name: "Pasaporte", slug: "passport" },
  { name: "CIF", slug: "cif" },
]

document_type_data.each do |d_attrs|
  MasterData::DocumentType.find_or_create_by!(slug: d_attrs[:slug]) do |d|
    d.name = d_attrs[:name]
    d.slug = d_attrs[:slug]
  end
end

puts "Se han creado los tipos de documento de identidad: #{MasterData::DocumentType.pluck(:name).join(', ')}"