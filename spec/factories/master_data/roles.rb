FactoryBot.define do
  factory :master_data_role, class: 'MasterData::Role' do
    sequence(:name) { |n| "Role #{n}" }
    sequence(:code) { |n| "role_#{n}" }
    scope { "tenant" }
    position { 5 }
    description { "role for testing" }
  end
end
