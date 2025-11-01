require 'rails_helper'

RSpec.describe Core::Address, type: :model do
  it { is_expected.to belong_to(:country) }
  it { is_expected.to belong_to(:address_type) }
  it { is_expected.to validate_presence_of(:street) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:postal_code) }
end
