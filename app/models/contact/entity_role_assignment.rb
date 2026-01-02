module Contact
  class EntityRoleAssignment < ApplicationRecord
    belongs_to :entity, class_name: "Core::Entity"
    belongs_to :entity_role, class_name: "Contact::EntityRole"
    belongs_to :state,
      class_name: "MasterData::EntityRoleAssignmentState"

    scope :active, -> {
      joins(:state).where(master_data_entity_role_assignment_states: { slug: "active" })
    }

    scope :archived, -> {
      joins(:state).where(master_data_entity_role_assignment_states: { slug: "archived" })
    }

    def active?
      state.slug == "active"
    end

    def archived?
      state.slug == "archived"
    end
  end
end


