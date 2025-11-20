Rails.application.routes.draw do
  devise_for :users, class_name: "Core::User"

  root to: "home#index"
end
