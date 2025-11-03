puts "🌍 Cargando tipos de impuesto..."

tax_type_data = [
  { name: "IVA", code: "iva", slug: "iva" },
  { name: "Recargo de equivalencia", code: "recargo", slug: "recargo" },
  { name: "IGIC", code: "igic", slug: "igic" },
  { name: "Exento", code: "exento", slug: "exento" },
  { name: "Reducido", code: "reducido", slug: "reducido" },
]

tax_type_data.each do |t_attrs|
  MasterData::TaxType.find_or_create_by!(slug: t_attrs[:slug]) do |t|
    t.name = t_attrs[:name]
    t.code = t_attrs[:code]
    t.slug = t_attrs[:slug]
  end
end

puts "Se han creado los tipos de impuesto: #{MasterData::TaxType.pluck(:name).join(', ')}"