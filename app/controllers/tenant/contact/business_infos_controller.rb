module Tenant
  class BusinessInfosController < Tenant::BaseController
    before_action :set_entity, only: [:new, :create, :edit, :update]
    before_action :set_business_info, only: [:edit, :update]

    def new
      @business_info = @entity.build_business_info

    end

    def create
      @business_info = @entity.build_business_info(business_info_params)
      @business_info.entity_id = @entity.id
      if @business_info.save
        redirect_to company_configuration_path, notice: "Datos de negocio guardados."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @business_info.update(business_info_params)
        redirect_to company_configuration_path, notice: "Datos de negocio actualizados."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_entity
      @entity = current_tenant_user.company.entities.first
    end

    def set_business_info
      @business_info = @entity.business_info
    end

    def business_info_params
      params.require(:core_business_info).permit(
        :entity_id,
        :slug, 
        :business_name,
        :trade_name,
        :tax_type_id,
        :registration_number,
        :phone,
        :email,
        :website
      )
    end
  end

end
