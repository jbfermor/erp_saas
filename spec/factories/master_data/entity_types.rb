FactoryBot.define do
  factory :master_data_entity_type, class: "MasterData::EntityType" do
    sequence(:name) { |n| "Tipo de entidad #{n}" }
    sequence(:code) { |n| "entity_type_#{n}" }
    sequence(:slug) { |n| "entity-type-#{n}" }

    trait :individual do
      name { "Persona física" }
      code { "individual" }
      slug { "individual" }
    end

    trait :business do
      name { "Empresa" }
      code { "business" }
      slug { "business" }
    end
  end
end
