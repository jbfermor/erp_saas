require "rails_helper"
require "active_record"

RSpec.describe MasterData::Seeder, type: :integration do
  let(:account) { create(:saas_account, database_name: "erp_saas_tenant_test") }
  let(:tenant_db) do
    create(:saas_tenant_database,
           account: account,
           host: "localhost",
           username: "postgres",
           password: "postgres",
           database_name: "erp_saas_tenant_test")
  end

  subject(:seeder) { described_class.new(account) }

  before do
    account.update!(tenant_database: tenant_db)
    MasterData::Country.create!(name: "España", iso_code: "ES", phone_prefix: "+34")
    MasterData::Role.create!(name: "Owner", position: 1, scope: "tenant", description: "Rol de propietario")

    # Limpia la base tenant antes del test
    ActiveRecord::Base.establish_connection(:tenant_test)
    ActiveRecord::Base.connection.execute("DROP SCHEMA public CASCADE; CREATE SCHEMA public;")
    ActiveRecord::Base.establish_connection(:test)
  end

  it "replica datos reales a la base del tenant" do
    seeder.seed!

    tenant_url = "postgres://postgres:postgres@localhost/erp_saas_tenant_test"
    ActiveRecord::Base.connected_to(database: { writing: tenant_url }) do
      countries = MasterData::Country.all
      roles = MasterData::Role.all

      expect(countries.count).to eq(1)
      expect(countries.first.name).to eq("España")

      expect(roles.count).to eq(1)
      expect(roles.first.name).to eq("Owner")
      expect(roles.first.scope).to eq("tenant")
    end
  end
end
