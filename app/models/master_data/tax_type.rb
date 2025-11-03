# == Schema Information
# Table name: core_tax_regimes
#  name   :string
#  code   :string
#  system :boolean
#
module MasterData
  class TaxType < ApplicationRecord
    has_many :business_infos, class_name: "Core::BusinessInfo", dependent: :restrict_with_error

    validates :name, :code, presence: true
    validates :code, uniqueness: true
  end
end
