# config/routes.rb

Rails.application.routes.draw do
  # Rutas globales del SaaS (landing, admin saas, etc.)
  namespace :saas do
    devise_for :users, class_name: 'Saas::User', module: :devise, controllers: {
      sessions: 'saas/devise/sessions',
      registrations: 'saas/devise/registrations'
    }
    root to: 'dashboard#index'
    resources :accounts
    resources :users
  end

  # Constraint para subdominios de tenants (excluye www, naked, etc)
  constraints ->(req) { req.subdomain.present? && req.subdomain != 'www' } do
    scope module: 'tenant', as: 'tenant' do
      # Importante: indicamos module y controllers apuntando a tenant/
      devise_for :users, class_name: 'Core::User', module: :devise, controllers: {
        sessions: 'tenant/devise/sessions',
        registrations: 'tenant/devise/registrations',
        passwords: 'tenant/devise/passwords'
      }

      # Rutas tenant nombradas prefix tenant_...
      get '/', to: 'dashboard#index', as: :dashboard
      resources :users, controller: 'users' # genera tenant_users_path
      # ... resto de rutas tenant
    end
  end

  # Fallback
  root to: 'home#index'
end
