Rails.application.routes.draw do
  # users
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  authenticated :user do
    root 'pages#dashboard', as: :authenticated_root
  end

  # pages
  root 'pages#landing'
  get 'pages/landing'

  # lessons
  resources :lessons
end
