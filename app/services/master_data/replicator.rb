module MasterData
  class Replicator
    def self.sync_all!
      # replicar todos los records a todos los tenants
      [MasterData::Module, MasterData::Plan, MasterData::PlanModule].each do |klass|
        klass.find_each do |r|
          MasterData::ReplicatorJob.perform_later(klass.name, r.id, action: "upsert")
        end
      end
    end
  end
end
