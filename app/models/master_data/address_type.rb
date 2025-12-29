# == Schema Information
# Table name: core_address_types
#  name        :string
#
module MasterData
  class AddressType < ApplicationRecord
    has_many :addresses, class_name: "Core::Address", dependent: :nullify

    validates :name, presence: true
  end
end
