require "rails_helper"

RSpec.describe Saas::Subscription, type: :model do
  it { is_expected.to belong_to(:account) }
  it { is_expected.to belong_to(:module) }

  it "no permite duplicadas por account y module" do
    account = create(:saas_account)
    mod = create(:saas_module)
    create(:saas_subscription, account:, module: mod)
    dup = build(:saas_subscription, account:, module: mod)
    expect(dup).not_to be_valid
  end
end
