module Saas
  class Role < ApplicationRecord
    self.table_name = "saas_roles"

    has_many :users, class_name: "Saas::User"

    validates :name, presence: true, uniqueness: true
  end
end
