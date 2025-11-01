FactoryBot.define do
  factory :saas_tax_type, class: "Saas::TaxType" do
    sequence(:name) { |n| "Tipo impuesto #{n}" }
    sequence(:code) { |n| "TAX#{n}" }
    sequence(:slug) { |n| "tipo-impuesto-#{n}" }
  end
end
