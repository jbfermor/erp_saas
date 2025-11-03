# == Schema Information
# Table name: core_addresses
#  addressable_type :string
#  addressable_id   :integer
#  street           :string
#  city             :string
#
module Core
  class Address < ApplicationRecord
    belongs_to :addressable, polymorphic: true
    belongs_to :address_type, class_name: "MasterData::AddressType"
    belongs_to :country, class_name: "MasterData::Country"

    validates :street, :city, :postal_code, presence: true
  end
end
