module Tenant
  class DashboardController < Tenant::BaseController

    def index
      @company = Core::Company.first
      @users_count = Core::User.non_system.count
      @modules = Core::Subscription.all
    end

    private

  end
end
