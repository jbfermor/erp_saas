# frozen_string_literal: true

module Saas
  module Devise
    class SessionsController < ::Devise::SessionsController
      layout "saas"

      # Después del login → dashboard del SaaS
      def after_sign_in_path_for(resource)
        saas_root_path
      end

      # Después del logout → /login
      def after_sign_out_path_for(resource)
        root_path
      end
    end
  end
end
