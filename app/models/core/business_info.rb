# == Schema Information
# Table name: core_business_infos
#  entity_id          :integer
#  tax_regime_id      :integer
#  business_name      :string
#  trade_name         :string
#  tax_id             :string
#
module Core
  class BusinessInfo < ApplicationRecord
    belongs_to :entity, class_name: "Core::Entity"
    belongs_to :tax_type, class_name: "MasterData::TaxType", optional: true
    
    has_one :address, as: :addressable, class_name: "Core::Address", dependent: :destroy

    accepts_nested_attributes_for :address

    validates :business_name, :tax_id, presence: true
    validates :tax_id, uniqueness: true
  end
end
