puts "🌍 Cargando tipos de impuesto..."

tax_type_data = [
  { name: "IVA", slug: "iva" },
  { name: "Recargo de equivalencia", slug: "recargo" },
  { name: "IGIC", slug: "igic" },
  { name: "Exento", slug: "exento" },
  { name: "Reducido", slug: "reducido" },
]

tax_type_data.each do |t_attrs|
  MasterData::TaxType.find_or_create_by!(slug: t_attrs[:slug]) do |t|
    t.name = t_attrs[:name]
    t.slug = t_attrs[:slug]
  end
end

puts "Se han creado los tipos de impuesto: #{MasterData::TaxType.pluck(:name).join(', ')}"