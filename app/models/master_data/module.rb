module MasterData
  class Module < ApplicationRecord
    has_many :plan_modules, class_name: "MasterData::PlanModule", 
              foreign_key: :master_data_module_id,dependent: :destroy

    has_many :plans, through: :plan_modules, class_name: "MasterData::Plan"

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
