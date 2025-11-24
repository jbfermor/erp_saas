require "rails_helper"

RSpec.describe MasterData::Module, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
end
