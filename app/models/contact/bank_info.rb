
module Contact
  class BankInfo < ApplicationRecord
    belongs_to :entity, class_name: "Core::Entity"

    validates :is_default, presence: true
    validates :iban, :slug, :swift, presence: true, uniqueness: true
    validates :bank_name, presence: true
  end
end
