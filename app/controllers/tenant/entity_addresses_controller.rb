# app/controllers/tenant/entity_addresses_controller.rb
module Tenant
  class EntityAddressesController < Tenant::BaseController
    before_action :set_entity
    before_action :set_address, only: [:edit, :update, :destroy]
    before_action :check_existing_work_address, only: [:new, :create]

    def new
      @address = @entity.addresses.build
      @address.address_type = work_address_type
    end

    def create
      @address = @entity.addresses.build(address_params)
      @address.address_type = work_address_type
      @address.slug = generate_slug(@address)

      if @address.save
        redirect_to company_configuration_path, notice: "Dirección añadida correctamente."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @address.update(address_params)
        redirect_to company_configuration_path, notice: "Dirección actualizada correctamente."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @address.destroy
      redirect_to company_configuration_path, notice: "Dirección eliminada."
    end

    private

    def set_entity
      @entity = current_tenant_user.company.entities.first
    end

    def set_address
      @address = @entity.addresses.find(params[:id])
    end

    def check_existing_work_address
      if @entity.work_address? && action_name == 'new'
        redirect_to edit_entity_address_path(@entity, @entity.work_address), 
                    alert: "Ya existe una dirección de trabajo. Puedes editarla."
      end
    end

    def work_address_type
      @work_address_type ||= MasterData::AddressType.find_by(slug: 'work')
    end

    def address_params
      params.require(:core_address).permit(
        :street,
        :city,
        :postal_code,
        :province,
        :country_id
        # ❌ NO permitir cambiar address_type_id (siempre será 'work')
      )
    end

    def generate_slug(address)
      "#{@entity.company.slug}-#{address.street.parameterize}"
    end
  end
end