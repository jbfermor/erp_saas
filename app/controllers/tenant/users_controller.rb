module Tenant
  class UsersController < Tenant::BaseController
    layout "tenant"
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = Core::User.non_system
    end

    def show
      
    end

    def new
      @user = Core::User.new
      @roles = MasterData::Role.where(scope: 'tenant')
    end

    def create
      @roles = MasterData::Role.where(scope: 'tenant')
      @user = Core::User.new(user_params)
      @user.company = Core::Company.find(current_tenant_user.company_id)
      Rails.logger.warn "PARAMS ROLE_ID: #{user_params[:role_id].inspect}"

      if @user.save
        redirect_to users_path, notice: "Usuario creado correctamente."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @roles = MasterData::Role.where(scope: 'tenant')
    end

    def update
      @roles = MasterData::Role.where(scope: 'tenant')
      if @user.update(user_params)
        redirect_to users_path, notice: "Usuario actualizado."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to users_path, notice: "Usuario eliminado."
    end

    private

    def set_user
      @user = Core::User.find(params[:id])
    end

    def user_params
      params.require(:core_user).permit(
        :email, :password, :password_confirmation, :role_id
      )
    end
    
  end
end
