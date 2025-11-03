FactoryBot.define do
  factory :master_data_tax_type, class: "MasterData::TaxType" do
    sequence(:name) { |n| "Tipo impuesto #{n}" }
    sequence(:code) { |n| "TAX#{n}" }
    sequence(:slug) { |n| "tipo-impuesto-#{n}" }
  end
end
