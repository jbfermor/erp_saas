puts "🌍 Cargando modulos..."

module_data = [
  { name: "Core", slug: "core" }
]

module_data.each do |m_attrs|
  MasterData::Module.find_or_create_by!(slug: m_attrs[:slug]) do |m|
    m.name = m_attrs[:name]
    m.slug = m_attrs[:slug]
  end
end

puts "Se han creado los módulos: #{MasterData::EntityType.pluck(:name).join(', ')}"