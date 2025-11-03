# == Schema Information
# Table name: core_bank_infos
#  entity_id  :integer
#  bank_name  :string
#  iban       :string
#  swift      :string
#
module Core
  class BankInfo < ApplicationRecord
    belongs_to :entity, class_name: "Core::Entity"

    validates :iban, :bank_name, presence: true, uniqueness: true
  end
end
