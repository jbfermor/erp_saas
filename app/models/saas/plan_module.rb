module Saas
  class PlanModule < ApplicationRecord
    belongs_to :plan, class_name: "Saas::Plan"
    belongs_to :module, class_name: "Saas::Module"

    validates :plan_id, uniqueness: { scope: :module_id }
  end
end
