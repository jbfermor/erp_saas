Rails.application.routes.draw do
  namespace :tenant do
    get "company_configuration/index"
  end

  # ============================================================
  # SaaS global (sin subdominio)
  # ============================================================
  namespace :saas do
    devise_for :users, class_name: 'Saas::User', module: :devise, controllers: {
      sessions: 'saas/devise/sessions',
      registrations: 'saas/devise/registrations'
    }
    root to: 'dashboard#index'
    resources :accounts
    resources :users
  end


  # ============================================================
  # TENANT por SUBDOMINIO (master.lvh.me, cliente1.lvh.me, etc)
  # ============================================================
  constraints lambda { |req|
    req.subdomain.present? && req.subdomain != "www"
  } do
    get "/__debug", to: proc { |env| [200, {}, ["TENANT DEBUG OK"]] }

    # Devise tenant (sin prefijo)
    devise_for :users,
      class_name: 'Core::User',
      module: :devise,
      path: '',
      controllers: {
        sessions: 'devise/sessions',
        registrations: 'devise/registrations',
        passwords: 'devise/passwords'
      },
      as: :tenant

    # Rutas tenant, SIN prefijo /tenant
    scope module: :tenant do
      root to: "dashboard#index", as: :tenant_root
      resources :users
      get 'company_configuration', to: 'company_configuration#index', as: 'company_configuration'
      resources :entities do
        scope module: :contact do
          resource :business_info, only: [:new, :create, :edit, :update]
          resource :bank_infos, only: [:new, :create, :edit, :update, :destroy]
          resource :address, controller: 'entity_addresses', only: [:new, :create, :edit, :update, :destroy]
        end
      end
    end
  end


  # ============================================================
  # Fallback (dominio sin subdominio)
  # ============================================================
  root to: "home#index"
end
