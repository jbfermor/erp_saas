FactoryBot.define do
  factory :saas_role, class: "Saas::Role" do
    sequence(:name) { |n| "Role #{n}" }
    sequence(:slug) { |n| "role-#{n}" }
    description { "Rol de prueba" }
    association :account, factory: :saas_account
  end
end
