FactoryBot.define do
  factory :master_data_plan, class: "MasterData::Plan" do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
  end
end
