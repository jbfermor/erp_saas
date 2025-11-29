module Tenant
  class BaseController < ApplicationController

    before_action :authenticate_tenant_user!
    layout "tenant"

    private

  end
end
