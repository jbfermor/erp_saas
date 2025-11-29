module Tenant
  class BaseController < ApplicationController
    before_action :require_tenant

    private

    def current_tenant
      request.env['current_tenant']
    end
    helper_method :current_tenant

    def require_tenant
      render plain: "Tenant not found", status: :not_found unless current_tenant
    end
  end
end
