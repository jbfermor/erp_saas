module MasterData
  class Module < ApplicationRecord
    self.table_name = "master_data_modules"
    has_many :plan_modules, class_name: "MasterData::PlanModule", 
              foreign_key: :master_data_module_id,dependent: :destroy

    has_many :master_data_plans, through: :plan_modules

    validates :name, :slug, presence: true

    after_commit :enqueue_replicator_on_create_update, on: [:create, :update]
    after_commit :enqueue_replicator_on_destroy, on: [:destroy]

    private

    def enqueue_replicator_on_create_update
      MasterData::ReplicatorJob.perform_later(self.class.name, self.id, action: "upsert")
    end

    def enqueue_replicator_on_destroy
      MasterData::ReplicatorJob.perform_later(self.class.name, self.id, action: "destroy")
    end
  end
end
