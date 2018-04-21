Rails.application.routes.draw do
  get 'choose-plan', to: 'plans#new', as: :choose_plan
  post 'choose-plan', to: 'plans#create'

  get 'billing' => 'billing#dashboard', as: :billing

  get 'choose-payment-method' => 'cards#new', as: :new_cards
  post 'choose-payment-method' => 'cards#create'
  post 'update-payment-method' => 'cards#update', as: :update_card
  put 'choose-default-payment-method/:id' => 'cards#default', as: :default_card
  delete 'delete-payment-method/:id' => 'cards#destroy', as: :delete_card

  post 'subscription' => 'subscriptions#create', as: :subscription
  delete 'subscription' => 'subscriptions#cancel'

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
