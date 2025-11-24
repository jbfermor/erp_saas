Rails.application.routes.draw do
  get "accounts/index"
  get "accounts/new"
  get "accounts/edit"
  get "accounts/show"
  # -----------------------------
  #  Core Users (Tenants)
  # -----------------------------
  devise_for :users,
             class_name: "Core::User",
             controllers: {
               sessions: "core/sessions"
             }

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
