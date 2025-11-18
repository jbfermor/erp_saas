require 'rails_helper'

RSpec.describe MasterData::DocumentType, type: :model do
  subject { create(:master_data_document) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }

end
