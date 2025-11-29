# frozen_string_literal: true

module Tenant
  module Devise
    class SessionsController < Devise::SessionsController
      layout "tenant"
      before_action :set_tenant_from_env


      # Después del login → dashboard del SaaS
      def after_sign_in_path_for(resource)
        tenant_dashboard_path
      end

      # Después del logout → /login
      def after_sign_out_path_for(resource)
        
      end

      private

      def set_tenant_from_env
        @current_tenant = request.env['current_tenant']
        raise "Missing tenant" unless @current_tenant
      end
      
    end
  end
end
