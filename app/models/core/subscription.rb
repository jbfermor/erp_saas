module Core
  class Subscription < ApplicationRecord
    belongs_to :company, class_name: "Core::Company"
    belongs_to :module,  class_name: "Saas::Module"

    validates :company_id, :module_id, presence: true
    validates :module_id, uniqueness: { scope: :company_id }
  end
end
