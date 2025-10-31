require 'rails_helper'

RSpec.describe Saas::Module, type: :model do
  it "is valid with valid attributes" do
    expect(build(:saas_module)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:saas_module, name: nil)).not_to be_valid
  end

  it "is invalid without a key" do
    expect(build(:saas_module, key: nil)).not_to be_valid
  end
end
