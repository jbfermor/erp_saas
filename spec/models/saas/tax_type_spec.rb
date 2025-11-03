require 'rails_helper'

RSpec.describe MasterData::TaxType, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }

end
