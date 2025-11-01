# == Schema Information
# Table name: core_address_types
#  name        :string
#  code        :string
#  company_id  :integer
#
class Saas::AddressType < ApplicationRecord
  belongs_to :company, class_name: "Core::Company", optional: true
  has_many :addresses, class_name: "Core::Address", dependent: :nullify

  validates :name, :code, presence: true
  validates :code, uniqueness: { scope: :company_id }, allow_blank: true
end
