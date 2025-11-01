require 'rails_helper'

RSpec.describe Saas::DocumentType, type: :model do
  subject { create(:saas_document_type) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }

end
