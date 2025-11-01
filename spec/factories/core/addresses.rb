FactoryBot.define do
  factory :core_address, class: 'Core::Address' do
    association :country, factory: :core_country
    association :address_type, factory: :core_address_type
    street { "Calle Mayor" }
    city { "Madrid" }
    postal_code { "28013" }
    region { "Madrid" }
  end
end
