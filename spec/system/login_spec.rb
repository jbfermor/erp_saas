require "rails_helper"

RSpec.describe "Tenant Login", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "permite login en subdominio correcto" do
    account = create(:saas_account, subdomain: "acme")
    tenant_db = create(:saas_tenant_database, saas_account: account)

    # Simular usuario dentro del tenant
    ActiveRecord::Base.establish_connection(tenant_db.connection_hash)
    company = create(:core_company, saas_account: account)
    user = create(:core_user, company: company, email: "admin@acme.com", password: "123456")

    visit "http://acme.saas.test/users/sign_in"

    fill_in "Email", with: "admin@acme.com"
    fill_in "Password", with: "123456"
    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
  end
end
