# == Schema Information
# Table name: core_business_infos
#  entity_id          :integer
#  tax_regime_id      :integer
#  business_name      :string
#  trade_name         :string
#
module Core
  class BusinessInfo < ApplicationRecord
    belongs_to :entity, class_name: "Core::Entity"
    belongs_to :tax_type, class_name: "MasterData::TaxType", optional: true


    validates :business_name, :tax_type_id, presence: true
    validates :registration_number, uniqueness: true
  end
end
