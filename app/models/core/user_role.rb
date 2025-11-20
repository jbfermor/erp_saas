module Core
  class UserRole < ApplicationRecord
    belongs_to :user, class_name: "Core::User"
    belongs_to :role, class_name: "MasterData::Role"
    belongs_to :company, class_name: "Core::Company"

    validates :user_id, uniqueness: { scope: [:role_id, :company_id], message: "ya tiene asignado este rol en la company" }
  end
end
