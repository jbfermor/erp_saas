FactoryBot.define do
  factory :master_data_country, class: 'MasterData::Country' do
    name { "España" }
    iso_code { "ES" }
    phone_prefix { "+34" }
    slug { "España" }
  end
end
