FactoryBot.define do
  factory :core_business_info, class: "Core::BusinessInfo" do
    association :entity, factory: :core_entity
    association :tax_type, factory: :saas_tax_type

    slug { "acme-sl" }
    business_name { "Acme S.L." }
    tax_id { "B12345678" }
  end
end
