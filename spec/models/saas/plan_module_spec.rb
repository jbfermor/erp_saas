require 'rails_helper'

RSpec.describe Saas::PlanModule, type: :model do
  let(:plan) { create(:saas_plan) }
  let(:mod)  { create(:saas_module) }

  it "is valid with valid associations" do
    expect(build(:saas_plan_module, plan:, module: mod)).to be_valid
  end

  it "requires a plan" do
    expect(build(:saas_plan_module, plan: nil)).not_to be_valid
  end

  it "requires a module" do
    expect(build(:saas_plan_module, module: nil)).not_to be_valid
  end

  it "enforces uniqueness of plan-module combination" do
    create(:saas_plan_module, plan:, module: mod)
    duplicate = build(:saas_plan_module, plan:, module: mod)
    expect(duplicate).not_to be_valid
  end
end
