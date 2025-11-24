require 'rails_helper'

RSpec.describe Saas::Plan, type: :model do
  it "creates a global plan and syncs modules" do
    create(:saas_module, key: "billing")
    create(:saas_module, key: "inventory")
    Saas::Plan.sync_global_modules!
    plan = Saas::Plan.global
    expect(plan.modules.count).to eq(2)
  end
end
