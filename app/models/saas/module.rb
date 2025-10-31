module Saas
  class Module < ApplicationRecord
    has_many :plan_modules, class_name: "Saas::PlanModule", dependent: :destroy
    has_many :plans, through: :plan_modules

    validates :name, :key, presence: true
    validates :key, uniqueness: true

    scope :active, -> { where(active: true) }
  end
end
