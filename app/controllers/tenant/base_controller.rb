module Tenant
  class BaseController < ApplicationController

    before_action :authenticate_tenant_user!   # o :authenticate_tenant_user! según tu Devise mapping
  
    layout "tenant"

  end
end
