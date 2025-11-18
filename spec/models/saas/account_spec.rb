require 'rails_helper'

RSpec.describe Saas::Account, type: :model do
  let(:plan) { create(:saas_plan) }

  it "es válido con nombre y plan " do
    account = described_class.new(
      name: "Cuenta Demo",
      slug: "demo",
      subdomain: "demo",
      database_name: "erp_demo",
      plan: plan
    )
    expect(account).to be_valid
  end

  it "is valid with valid attributes" do
    account = build(:saas_account, plan:)
    expect(account).to be_valid
  end

  it "requires a name and slug" do
    expect(build(:saas_account, name: nil)).not_to be_valid
    expect(build(:saas_account, slug: nil)).not_to be_valid
  end

end
