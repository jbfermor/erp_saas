require 'rails_helper'

RSpec.describe "Tenant::CompanyConfigurations", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/tenant/company_configuration/index"
      expect(response).to have_http_status(:success)
    end
  end

end
