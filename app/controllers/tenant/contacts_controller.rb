module Tenant
  class ContactsController < Tenant::BaseController
    before_action :current_company, only: [:index]

    def index

      @roles = ::Contact::EntityRole.all

      @entities = Core::Entity
        .includes(
          :personal_info,
          :business_info,
          entity_role_assignments: [:entity_role, :state]
        )

      if params[:role].present?
        @entities = @entities
          .joins(:entity_role_assignments)
          .merge(Contact::EntityRoleAssignment.active)
          .where(contact_entity_role_assignments: {
            entity_role_id: params[:role]
          })
          .distinct
      end
    end

    private

    def current_company
      @company = current_tenant_user.company 
    end

  end
end
