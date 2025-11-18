require "rails_helper"

RSpec.describe MasterData::Seeder, type: :service do
  let(:account) { create(:saas_account) }
  let(:tenant_db) { create(:saas_tenant_database, account: account, database_name: "tenant_test_db") }

  subject(:seeder) { described_class.new(account) }

  before do
    account.update!(tenant_database: tenant_db)

    # Simulamos que existen registros en la BD maestra
    MasterData::Country.create!(name: "España", iso_code: "ES", phone_prefix: "+34")
    MasterData::Role.create!(name: "Admin", position: 1, scope: "tenant", description: "Administrador general")

    allow(seeder).to receive(:connection_url_for).and_return("postgres://postgres:postgres@localhost/tenant_test_db")
    allow(ActiveRecord::Base).to receive(:connected_to).and_yield
  end

  describe "#seed!" do
    it "replica todos los modelos master_data" do
      expect(seeder).to receive(:replicate_model_to_tenant).with(MasterData::Country, anything)
      expect(seeder).to receive(:replicate_model_to_tenant).with(MasterData::Role, anything)
      seeder.seed!
    end

    it "lanza un error si la cuenta no tiene tenant_database" do
      account.update!(tenant_database: nil)
      expect { described_class.new(account).seed! }.to raise_error(ArgumentError)
    end
  end

  describe "#replicate_model_to_tenant" do
    let(:tenant_url) { "postgres://postgres:postgres@localhost/tenant_test_db" }

    it "copia registros desde el modelo global al tenant" do
      records = MasterData::Country.all
      expect(records.count).to eq(1)

      # Simulamos conexión al tenant
      expect(ActiveRecord::Base).to receive(:connected_to).with(database: { writing: tenant_url }).and_yield

      expect(MasterData::Country).to receive(:delete_all)
      expect(MasterData::Country).to receive(:create!).at_least(:once)

      seeder.send(:replicate_model_to_tenant, MasterData::Country, tenant_url)
    end
  end
end
