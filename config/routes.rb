Rails.application.routes.draw do
  get 'choose-plan', to: 'plans#new', as: :choose_plan
  post 'choose-plan', to: 'plans#create'

  get 'billing' => 'billing#dashboard', as: :billing
  get 'billing/new' => 'billing#new', as: :payment_method
  post 'billing/new' => 'billing#create'
  post 'billing/subscribe' => 'billing#subscribe', as: :subscribe
  post 'billing/receive' => 'billing#subscribe', as: :receive
  delete 'billing/cancel' => 'billing#cancel', as: :cancel_subscription

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  authenticated :user do
    root 'lessons#index', as: :authenticated_root
  end

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

  resources :lessons
end
