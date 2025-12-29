module Tenant
  class CompanyConfigurationController < BaseController
    before_action :set_company, only: [:index]
    before_action :set_entity, only: [:index]

    def index
        @bussiness_info = @entity.business_info
        @bank_infos = @entity.bank_infos
        flash[alert] = "No hay información de la empresa configurada." if @entity.business_info.nil?
        flash[alert] = "No hay información bancaria configurada." if @entity.bank_infos.empty?
    end

    private

    def set_company
      @company = current_tenant_user.company
    end

    def set_entity
      @entity =  current_tenant_user.company.entities.first
    end

  end
end

