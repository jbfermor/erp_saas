FactoryBot.define do
  factory :core_user_role, class: "Core::UserRole" do
    association :user, factory: :core_user
    association :role, factory: :saas_role
    association :company, factory: :core_company
  end
end
