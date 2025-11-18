# spec/factories/saas/tenant_databases.rb
FactoryBot.define do
  factory :saas_tenant_database, class: 'Saas::TenantDatabase' do
    association :account, factory: :saas_account, strategy: :build # no lo crea en cascada
    sequence(:database_name) { |n| "tenant_db_#{n}" }
    host { "localhost" }
    port { 5432 }
    username { "postgres" }
    password { "postgres" }
  end
end
