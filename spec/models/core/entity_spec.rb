require 'rails_helper'

RSpec.describe Core::Entity, type: :model do

  let(:entity_type_individual) { create(:saas_entity_type, name: "Individual") }
  let(:entity_type_business) { create(:saas_entity_type, name: "Business") }
  let(:company) { create(:core_company) }

  it { is_expected.to have_one(:personal_info) }
  it { is_expected.to have_one(:business_info) }
  it { is_expected.to have_many(:addresses) }
  it { is_expected.to have_many(:bank_infos) }

  it "es válido con información personal" do
    entity = create(:core_entity, :with_personal_info, entity_type: entity_type_individual, company: company)
    expect(entity).to be_valid
    expect(entity.personal_info).to be_present
  end

  it "es válido con información empresarial" do
    entity = create(:core_entity, :with_business_info, entity_type: entity_type_business, company: company)
    expect(entity.business_info).to be_present
  end

  it "requiere un tipo de entidad válido" do
    entity = build(:core_entity, entity_type: nil)
    expect(entity).not_to be_valid
  end
end
