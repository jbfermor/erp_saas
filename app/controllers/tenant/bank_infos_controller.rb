module Tenant
  class BankInfosController < Tenant::BaseController
    before_action :set_entity
    before_action :set_bank_info, only: [:edit, :update]

    def new
      @bank_info = @entity.build_bank_info
    end

    def create
      @bank_info = @entity.build_bank_info(bank_info_params)
      if @bank_info.save
        redirect_to company_configuration_path, notice: "Datos bancarios guardados."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @bank_info.update(bank_info_params)
        redirect_to company_configuration_path, notice: "Datos bancarios actualizados."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_entity
      @entity = current_tenant_user.company.entity
    end

    def set_bank_info
      @bank_info = @entity.bank_info
    end

    def bank_info_params
      params.require(:bank_info).permit(
        :entity_id,
        :is_default,
        :iban,
        :swift,
        :bank_name,
        :slug
      )
    end
  end
end
