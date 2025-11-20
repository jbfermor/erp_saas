module Core
  class SessionsController < Devise::SessionsController
    include TenantScoped

    prepend_before_action :ensure_tenant!
    before_action :ensure_user_belongs_to_tenant, only: :create


    private

    def ensure_tenant!
      unless request.env["saas.current_account"]
        redirect_to root_path, alert: "No tenant"
      end
    end

    def ensure_user_belongs_to_tenant
      user = Core::User.find_by(email: params[:user][:email])
      if user && user.company_id != current_company.id
        redirect_to new_user_session_path, alert: "Usuario no pertenece a este tenant"
      end
    end
    
  end
end
