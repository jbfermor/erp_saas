Rails.application.routes.draw do
  namespace :tenant do
    get "dashboard/index"
  end

  # -----------------------
  # ZONA PÚBLICA (sin subdominio)
  # -----------------------
  constraints(subdomain: '') do
    authenticated :user do
      root to: "dashboard#index", as: :authenticated_root
    end

    unauthenticated do
      root to: "home#index"
    end

    # -----------------------------
    #  SaaS Admin login (Saas::User)
    # -----------------------------
    devise_for :saas_users,
              class_name: "Saas::User",
              path: "",
              controllers: {
                sessions: "saas/sessions"
              }

    devise_scope :saas_user do
      get    "/login",  to: "saas/sessions#new"
      post   "/login",  to: "saas/sessions#create"
      delete "/logout", to: "saas/sessions#destroy"
    end

    # -----------------------------
    # SaaS Admin Dashboard
    # -----------------------------
    namespace :saas_admin do
      get "/", to: "dashboard#index", as: :dashboard
      resources :users
      resources :accounts
    end
  end

  # -----------------------
  # ZONA MULTITENANT (con subdominio)
  # -----------------------
  constraints(SubdomainRequired) do
    scope module: 'tenant' do
      root to: 'dashboard#index', as: :tenant_root
      # -----------------------------
      #  Core Users (Tenants)
      # -----------------------------
      devise_for :users,
             class_name: "Core::User",
             controllers: {
               sessions: "core/sessions"
             }
      # cualquier módulo más…
    end
  end
  
end
