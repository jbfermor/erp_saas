module MasterData
  class Plan < ApplicationRecord
    
    self.table_name = "master_data_plans"
    has_many :plan_modules,
            class_name: "MasterData::PlanModule",
            foreign_key: :master_data_plan_id,
            dependent: :destroy

    has_many :master_data_modules,
           through: :plan_modules

    has_many :company_plans,
         class_name: "MasterData::CompanyPlan",
         foreign_key: :master_data_plan_id,
         dependent: :restrict_with_error

    validates :name, :slug, presence: true

    after_commit :enqueue_replicator, on: [:create, :update]
    after_commit :enqueue_replicator_destroy, on: [:destroy]

    private

    def enqueue_replicator
      MasterData::ReplicatorJob.perform_later(self.class.name, self.id, action: "upsert")
    end

    def enqueue_replicator_destroy
      MasterData::ReplicatorJob.perform_later(self.class.name, self.id, action: "destroy")
    end
  end
end
