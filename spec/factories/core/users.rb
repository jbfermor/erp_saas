FactoryBot.define do
  factory :core_user, class: "Core::User" do
    email { Faker::Internet.unique.email }
    password { "password123" }
    association :entity, factory: :core_entity
    association :company, factory: :core_company

    after(:create) do |user|
      create(:core_user_role, user: user, role: create(:saas_role, name: "staff"))
    end
  end
end
