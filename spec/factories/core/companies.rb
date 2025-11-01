FactoryBot.define do
  factory :core_company, class: "Core::Company" do
    sequence(:name) { |n| "Company #{n}" }
    sequence(:slug) { |n| "company-#{n}" }
    association :saas_account, factory: :saas_account
  end
end
