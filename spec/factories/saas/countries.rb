FactoryBot.define do
  factory :saas_country, class: 'Saas::Country' do
    name { "España" }
    iso_code { "ES" }
    phone_prefix { "+34" }
    slug { "España" }
  end
end
