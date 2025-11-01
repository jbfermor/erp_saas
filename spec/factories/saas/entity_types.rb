FactoryBot.define do
  factory :saas_entity_type, class: "Saas::EntityType" do
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
