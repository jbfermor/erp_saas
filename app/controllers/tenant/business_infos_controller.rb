module Tenant
  class BusinessInfosController < Tenant::BaseController
    before_action :set_entity
    before_action :set_business_info, only: [:edit, :update]

    def new
      @business_info = @entity.build_business_info
      @business_info.build_address unless @business_info.address

    end

    def create
      @business_info = @entity.build_business_info(business_info_params)
      @business_info.entity_id = @entity.id
      @business_info.slug = business_info_params[:trade_name].parameterize
      business_info_params[:address_attributes][:address_type_id] ||= MasterData::AddressType.find_by(slug: 'work').id
      if @business_info.save
        redirect_to company_configuration_path, notice: "Datos de negocio guardados."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @business_info.build_address unless @business_info.address
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
      @entity = current_tenant_user.company.entity
    end

    def set_business_info
      @business_info = @entity.business_info
    end

    def business_info_params
      params.require(:business_info).permit(
        :entity_id,
        :tax_type_id,
        :slug, 
        :business_name,
        :trade_name,
        :tax_id,
        :registration_number,
        :phone,
        :email,
        :website,
        address_attributes: [
          :id,
          :street,
          :city,
          :postel_code,
          :address_type_id,
          :country_id
        ]
      )
    end
  end

end
