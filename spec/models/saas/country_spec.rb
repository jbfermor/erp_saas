require 'rails_helper'

RSpec.describe MasterData::Country, type: :model do
  subject { create(:master_data_country) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:iso_code) }

end
