module Saas
  class BaseController < ApplicationController
    before_action :authenticate_saas_user!
    layout "saas"
  end
end
