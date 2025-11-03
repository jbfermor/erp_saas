# == Schema Information
# Table name: core_address_types
#  name        :string
#  code        :string
#  company_id  :integer
#
module MasterData
  class AddressType < ApplicationRecord
    has_many :addresses, class_name: "Core::Address", dependent: :nullify

    validates :name, :code, presence: true
  end
end
