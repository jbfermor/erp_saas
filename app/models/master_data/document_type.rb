module MasterData
  class DocumentType < ApplicationRecord
    has_many :personal_infos, class_name: "Core::PersonalInfo", dependent: :restrict_with_error

    validates :name, presence: true
  end
end
