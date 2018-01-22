Rails.application.routes.draw do
  # stripe
  resources :charges
  
  # users
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  authenticated :user do
    root 'lessons#index', as: :authenticated_root
  end

  # pages
  root 'pages#landing'
  get 'dashboard', to: 'pages#dashboard'
  get 'panel', to: 'pages#panel'
  get 'choose-us', to: 'pages#choose_us'
  get 'rates', to: 'pages#rates'
  get 'services', to: 'pages#services'
  get 'get-started', to: 'pages#get_started'
  get 'about', to: 'pages#about'
  get 'our-program', to: 'pages#our_program'
  get 'contact-us', to: 'pages#contact_us'

  # lessons
  resources :lessons
end
