class MasterData::PlanBootstrapService

  def initialize
  end

  def call
    plan = MasterData::Plan.find_or_create_by!(
      name: "Global Plan"
    ) do |p|
      p.slug = "global_plan"
      p.description = "Plan global con todos los módulos"
    end

    MasterData::Module.find_each do |mod|
      plan.master_data_modules << mod unless plan.master_data_modules.exists?(mod.id)
    end

    return plan

  end
end
