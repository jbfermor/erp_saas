module Tenant
  class UsersController < Tenant::BaseController
    layout "tenant"
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = Core::User.all
    end

    def show
      
    end

    def new
      @user = Tenant::User.new
    end

    def create
      @user = Tenant::User.new(user_params)
      if @user.save
        redirect_to users_path, notice: "Usuario creado correctamente."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to users_path, notice: "Usuario actualizado."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to sers_path, notice: "Usuario eliminado."
    end

    private

    def set_user
      @user = Tenant::User.find(params[:id])
    end

    def user_params
      params.require(:saas_user).permit(
        :email, :password, :password_confirmation, :saas_role_id
      )
    end
    
  end
end
