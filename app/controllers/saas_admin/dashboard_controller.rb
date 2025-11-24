module SaasAdmin
  class DashboardController < SaasAdmin::BaseController
    before_action :authenticate_saas_user!

    def index
    end
  end
end
