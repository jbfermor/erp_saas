FactoryBot.define do
  factory :master_data_module, class: "MasterData::Module" do
    name { Faker::Commerce.department }
    slug { Faker::Internet.unique.slug }
    active { true }
  end
end
