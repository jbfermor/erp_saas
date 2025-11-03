FactoryBot.define do
  factory :saas_tenant_database, class: 'Saas::TenantDatabase' do
    association :account, factory: :saas_account
    host { "localhost" }
    port { 5432 }
    username { ENV['PGUSER'] || 'postgres' }
    password { ENV['PGPASSWORD'] || 'postgres' }
    sequence(:database_name) { |n| "erp_test_db_#{n}" }
  end
end
