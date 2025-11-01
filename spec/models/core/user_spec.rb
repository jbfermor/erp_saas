require 'rails_helper'

RSpec.describe Core::User, type: :model do
  it { should belong_to(:entity).optional }
  it { should have_many(:user_roles).dependent(:destroy) }
  it { should have_many(:roles).through(:user_roles) }

  it { should validate_presence_of(:email) }

  let(:user) { create(:core_user) }
  let(:company) { create(:core_company) }

  it "es válido con email y password" do
    expect(user).to be_valid
  end

  it "requiere email único" do
    create(:core_user, email: "test@example.com")
    user2 = build(:core_user, email: "test@example.com")
    expect(user2).not_to be_valid
  end
end
