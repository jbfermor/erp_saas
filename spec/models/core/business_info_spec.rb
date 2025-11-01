require 'rails_helper'

RSpec.describe Core::BusinessInfo, type: :model do
  it { is_expected.to validate_presence_of(:business_name) }
  it { is_expected.to validate_presence_of(:tax_id) }
end
