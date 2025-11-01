# == Schema Information
# Table name: core_addresses
#  addressable_type :string
#  addressable_id   :integer
#  street           :string
#  city             :string
#
class Core::Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  belongs_to :address_type, class_name: "Saas::AddressType"
  belongs_to :country, class_name: "Saas::Country"

  validates :street, :city, :postal_code, presence: true
end
