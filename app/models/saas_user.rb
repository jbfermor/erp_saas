module Saas
  class User < ApplicationRecord
    self.table_name = "saas_users"

    devise :database_authenticatable, :recoverable, :rememberable, :validatable

    belongs_to :role, class_name: "Saas::Role"

    delegate :name, to: :role, prefix: true
  end
end
