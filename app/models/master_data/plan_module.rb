module MasterData
  class PlanModule < ApplicationRecord
    self.table_name = "master_data_plan_modules"

    belongs_to :master_data_plan, class_name: "MasterData::Plan", foreign_key: :master_data_plan_id
    belongs_to :master_data_module, class_name: "MasterData::Module", foreign_key: :master_data_module_id

    validates :master_data_plan_id, uniqueness: { scope: :master_data_module_id }

    after_commit :enqueue_replicator, on: [:create, :update, :destroy]

    private

    def enqueue_replicator
      MasterData::ReplicatorJob.perform_later(self.class.name, self.id, action: "upsert")
    end
  end
end