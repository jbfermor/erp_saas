class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @company = current_company
    @tenant = current_tenant
    @user_roles = current_user.roles.where(user_roles: { company_id: @company.id })
  end
end
