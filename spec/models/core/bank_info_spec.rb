require 'rails_helper'

RSpec.describe Core::BankInfo, type: :model do
  it { is_expected.to validate_presence_of(:iban) }
  it { is_expected.to validate_presence_of(:bank_name) }
end
