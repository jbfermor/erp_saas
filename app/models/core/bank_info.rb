
module Core
  class BankInfo < ApplicationRecord
    belongs_to :entity, class_name: "Core::Entity"

    validates :is_default, presence: true
    validates :iban, :bank_name, :slug, :swift, presence: true, uniqueness: true
  end
end
