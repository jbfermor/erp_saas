class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :connect_to_tenant_db

  helper_method :current_tenant
  def current_tenant
    # No devuelves la Account, sino un objeto de la DB del tenant
    Core::Company.first # O si tienes varias, el contexto de la compañía principal
  end

  private

  def connect_to_tenant_db
    return unless request.env["tenant_db_config"]

    # Cambia la conexión a la base de datos del tenant
    ActiveRecord::Base.establish_connection(request.env["tenant_db_config"])
  end

end

