require 'rails_helper'

RSpec.describe Core::UserRole, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:role) }
  it { should belong_to(:company) }

  let(:user) { create(:core_user) }
  let(:role) { create(:saas_role) }
  let(:company) { create(:core_company) }

  it "es válido con user, role y company" do
    user_role = build(:core_user_role, user: user, role: role, company: company)
    expect(user_role).to be_valid
  end

  it "no permite duplicados por user, role y company" do
    create(:core_user_role, user: user, role: role, company: company)
    dup = build(:core_user_role, user: user, role: role, company: company)
    expect(dup).not_to be_valid
  end
end
