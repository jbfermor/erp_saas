require 'rails_helper'

RSpec.describe Core::Company, type: :model do
  subject { create(:core_company) }
  it { is_expected.to validate_uniqueness_of(:slug) }
  it { should belong_to(:saas_account) }
  it { should have_many(:users).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }
end
