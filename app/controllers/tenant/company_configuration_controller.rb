module Tenant
  class CompanyConfigurationController < BaseController
    before_action :set_company, only: [:index]
    before_action :set_company_entity, only: [:index]

    def index
        @bussiness_info = @company_entity.business_info
        @bank_infos = @company_entity.bank_infos
        flash[alert] = "No hay información de la empresa configurada." if @company_entity.business_info.nil?
        flash[alert] = "No hay información bancaria configurada." if @company_entity.bank_infos.empty?
    end

    private

    def set_company
      @company = Core::Company.find(current_tenant_user.company.id)
    end

    def set_company_entity
      @company_entity = Core::Entity.first
    end

  end
end

