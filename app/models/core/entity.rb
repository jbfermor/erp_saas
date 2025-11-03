# == Schema Information
# Table name: core_entities
#  entity_type_id :integer
#  company_id     :integer
#
module Core
  class Entity < ApplicationRecord
    belongs_to :entity_type, class_name: "MasterData::EntityType"
    belongs_to :company, class_name: "Core::Company"

    has_one :personal_info, class_name: "Core::PersonalInfo", dependent: :destroy
    has_one :business_info, class_name: "Core::BusinessInfo", dependent: :destroy
    has_many :addresses, as: :addressable, class_name: "Core::Address", dependent: :destroy
    has_many :bank_infos, class_name: "Core::BankInfo", dependent: :destroy

  end
end
