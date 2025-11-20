require 'rails_helper'

RSpec.describe TenantResolver do
  let(:app) { ->(env) { [200, env, "OK"] } }
  let(:middleware) { described_class.new(app) }

  it "resuelve tenant por subdominio" do
    env = Rack::MockRequest.env_for("http://acme.saas.test")
    status, headers, response = middleware.call(env)

    expect(env["saas.current_account"].slug).to eq("acme")
  end

  it "si no existe el subdominio, no asigna tenant" do
    env = Rack::MockRequest.env_for("http://www.saas.test")
    status, headers, response = middleware.call(env)

    expect(env["saas.current_account"]).to be_nil
  end
end
