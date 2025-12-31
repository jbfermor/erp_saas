
module MasterData
  class AddressType < ApplicationRecord
    self.table_name = "master_data_address_types"
    has_many :addresses, class_name: "Contact::Address", dependent: :nullify
    validates :name, presence: true
  end
end
