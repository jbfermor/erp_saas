require "rails_helper"

RSpec.describe TenantScopedController, type: :controller do
  controller(ApplicationController) do
    include TenantScoped
    def index
      render plain: ActiveRecord::Base.connection_db_config.database
    end
  end

  it "cambia a la base de datos del tenant antes de ejecutar acción" do
    account = create(:saas_account, subdomain: "acme")
    tenant_db = create(:saas_tenant_database, saas_account: account,
                       database_name: "tenant_acme")

    request.host = "acme.saas.test"
    get :index

    expect(response.body).to eq("tenant_acme")
  end
end
