require 'rails_helper'

RSpec.describe Saas::Role, type: :model do
  it { should belong_to(:account) }
  it { should have_many(:user_roles).dependent(:destroy) }
  it { should have_many(:users).through(:user_roles) }

  it { should validate_presence_of(:name) }
end
