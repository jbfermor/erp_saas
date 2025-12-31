
module MasterData
  class Country < ApplicationRecord
    has_many :addresses, class_name: "Core::Address", dependent: :nullify

    validates :name, :iso_code, presence: true
    validates :iso_code, uniqueness: true
  end
end
