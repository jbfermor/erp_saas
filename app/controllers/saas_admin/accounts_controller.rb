module SaasAdmin
  class AccountsController < SaasAdmin::BaseController
    layout "saas"  # si tu layout del panel saas se llama así

    before_action :set_account, only: [:show, :edit, :update, :destroy]

    def index
      @accounts = Saas::Account.all
    end

    def new
      @account = Saas::Account.new
      @account.build_saas_tenant_database
    end

    def create
      @account = Saas::Account.new(account_params)

      if @account.save
        # Provisionado del tenant
        begin
          @account.setup_tenant!(
            tenant_database_data: @account.saas_tenant_database.connection_hash,
            saas_account: @account,
            company_data: {
              name: @account.company_name,
              slug: @account.company_slug,
              cif: @account.company_cif
            },
            owner_email: @account.owner_email,
            owner_password: "changeme"
          )
        rescue => e
          flash[:alert] = "Account creada, pero error inicializando tenant: #{e.message}"
        end

        redirect_to saas_admin_account_path(@account), notice: "Account creada correctamente."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @account.build_saas_tenant_database if @account.saas_tenant_database.nil?
    end

    def update
      if @account.update(account_params)
        redirect_to saas_admin_account_path(@account), notice: "Account actualizada."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def show
    end

    def destroy
      @account.destroy
      redirect_to saas_accounts_path, notice: "Account eliminada."
    end

    private

    def set_account
      @account = Saas::Account.find(params[:id])
    end

    def account_params
      params.require(:saas_account).permit(
        :name, :slug,
        saas_tenant_database_attributes: [
          :database_name, :username, :password, :host, :port, :id
        ]
      )
    end
  end
end
