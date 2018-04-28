Rails.application.routes.draw do
  resources :stacks, except: :index
  resources :categories, except: [:show, :index]
  get 'library', to: 'categories#index', as: :library
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
    root 'categories#index', as: :authenticated_root
  end

  root 'pages#landing'
  get '' => 'pages#landing', as: :landing
  post 'contact-us' => 'pages#contact_us', as: :contact_us
  post 'updates' => 'pages#updates', as: :updates
  get 'dashboard', to: 'pages#dashboard'
  get 'panel', to: 'pages#panel', as: 'panel'
  

  resources :lessons, except: :index
  post '/tinymce_assets' => 'lessons#images'
end
