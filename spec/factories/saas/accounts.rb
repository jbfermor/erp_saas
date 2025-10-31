FactoryBot.define do
  factory :saas_account, class: 'Saas::Account' do
    sequence(:name) { |n| "Account #{n}" }
    sequence(:slug) { |n| "account_#{n}" }
    sequence(:subdomain) { |n| "sub#{n}" }
    sequence(:database_name) { |n| "tenant_db_#{n}" }
    association :plan, factory: :saas_plan
    status { "active" }
    metadata { { created_by: "system" } }
  end
end
