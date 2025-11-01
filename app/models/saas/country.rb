# == Schema Information
# Table name: core_countries
#  name          :string
#  iso_code      :string
#  phone_prefix  :string
#
class Saas::Country < ApplicationRecord
  has_many :addresses, class_name: "Core::Address", dependent: :nullify

  validates :name, :iso_code, presence: true
  validates :iso_code, uniqueness: true
end
