module SaasAdmin
  class DashboardController < ApplicationController
    before_action :authenticate_saas_user!

    layout "saas"

    def index
    end
  end
end
