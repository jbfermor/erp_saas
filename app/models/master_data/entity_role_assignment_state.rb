module MasterData
  class EntityRoleAssignmentState < ApplicationRecord
    self.table_name = "master_data_entity_role_assignment_states"

    validates :slug, presence: true, uniqueness: true

    def self.active
      find_by!(slug: "active")
    end

    def self.archived
      find_by!(slug: "archived")
    end
  end
end
