module Core
  class Subscription < ApplicationRecord
    belongs_to :company, class_name: "Core::Company"
    belongs_to :module, class_name: "MasterData::Module"

    validates :company_id, :module_id, presence: true

  end
end
