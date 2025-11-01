require 'rails_helper'

RSpec.describe Saas::Country, type: :model do
  subject { create(:saas_country) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:iso_code) }

end
