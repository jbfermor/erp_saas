module Tenant
  class BankInfosController < Tenant::BaseController
    before_action :set_entity
    before_action :set_bank_info, only: [:destroy]

    def new
      @bank_info = @entity.bank_infos.build
    end

    def create
      @bank_info = @entity.bank_infos.build(bank_info_params)
      @bank_info.slug = generate_slug(@bank_info)  # ← Auto-generar slug

      if @bank_info.save
        redirect_to company_configuration_path, notice: "Datos bancarios guardados."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @bank_info.destroy
      redirect_to company_configuration_path, notice: "Datos bancarios eliminados."
    end

    private

    def set_entity
      @entity = current_tenant_user.company.entities.first
    end

    def set_bank_info
      @bank_info = @entity.bank_infos.find(params[:format])
    end

    def bank_info_params
      params.require(:core_bank_info).permit(
        :entity_id,
        :is_default,
        :iban,
        :swift,
        :bank_name,
        :slug
      )
    end

    def generate_slug(bank_info)
      "#{@entity.company.slug}-#{bank_info.bank_name.parameterize}-#{bank_info.iban.last(4)}"
    end
    
  end
end
