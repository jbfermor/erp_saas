module Saas
  class Plan < ApplicationRecord
    has_many :plan_modules, class_name: "Saas::PlanModule", dependent: :destroy
    has_many :modules, through: :plan_modules

    validates :name, :key, presence: true
    validates :key, uniqueness: true

    scope :active, -> { where(active: true) }

    def self.global
      find_or_create_by!(key: "global") do |plan|
        plan.name = "Global Access Plan"
        plan.description = "Acceso completo a todos los módulos"
        plan.active = true
      end
    end

    def self.sync_global_modules!
      global_plan = global
      Saas::Module.find_each do |mod|
        global_plan.modules << mod unless global_plan.modules.include?(mod)
      end
      global_plan.save!
    end
  end
end
