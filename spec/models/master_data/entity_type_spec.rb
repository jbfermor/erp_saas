# spec/models/saas/entity_type_spec.rb
require "rails_helper"

RSpec.describe MasterData::EntityType, type: :model do
  subject { create(:master_data_entity_type) }

  # Validaciones
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }

  # Relaciones
  it { is_expected.to have_many(:entities).class_name("Core::Entity").dependent(:nullify) }

  # Factory
  describe "Factory" do
    it "es válida" do
      expect(build(:master_data_entity_type)).to be_valid
    end
  end
end
