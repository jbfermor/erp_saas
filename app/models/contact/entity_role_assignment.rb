module Contact
  class EntityRoleAssignment < ApplicationRecord
    belongs_to :entity, class_name: "Core::Entity"
    belongs_to :entity_role, class_name: "Contact::EntityRole"
  end
end
