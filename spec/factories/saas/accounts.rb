FactoryBot.define do
  factory :saas_account, class: 'Saas::Account' do
    sequence(:name) { |n| "Account #{n}" }
    sequence(:slug) { |n| "account-#{n}" }
    sequence(:subdomain) { |n| "acc#{n}" }
    database_name { "erp_test_#{SecureRandom.hex(4)}" }
    after(:create) do |acc|
      create(:saas_tenant_database, account: acc)
    end
    association :plan, factory: :saas_plan
    status { "active" }

    trait :with_tenant_db do
      after(:create) do |acc|
        create(:saas_tenant_database, account: acc)
      end
    end
    
  end
end
