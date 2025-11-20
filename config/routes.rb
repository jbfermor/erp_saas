Rails.application.routes.draw do
  devise_for :users, class_name: "Core::User",
  controllers: {
    sessions: "core/sessions"
  }

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "home#index"
  end

  namespace :saas do
    devise_for :users,
      class_name: "Saas::User",
      path: "",
      controllers: {
        sessions: "saas/sessions",
        passwords: "saas/passwords"
      }
  end

end
