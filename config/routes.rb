Rails.application.routes.draw do
  post '/complete/:resource_type/:resource_id' => 'completions#create', as: :complete

  resources :stack_tracks

  resources :tracks
  post 'tracks/:id/select' => 'tracks#select', as: :select_track

  resources :categories, except: [:show, :index]
  get 'library', to: 'categories#index', as: :library

  resources :stacks, except: [:index, :new]
  get 'stacks/new/:category_id' => 'stacks#new', as: :new_stack

  resources :lessons, except: [:index, :new]
  get 'lessons/new/:stack_id' => 'lessons#new', as: :new_lesson
  post '/tinymce_assets' => 'lessons#images'

  # dashboard
  get 'dashboard', to: 'pages#dashboard', as: :dashboard

  # on-boarding
  get 'choose-plan', to: 'plans#new', as: :choose_plan
  post 'choose-plan', to: 'plans#create'
  get 'choose-payment-method' => 'cards#new', as: :new_cards
  post 'choose-payment-method' => 'cards#create'

  # settings
  get 'billing' => 'billing#dashboard', as: :billing
  
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
    root 'pages#dashboard', as: :authenticated_root
  end

  root 'pages#landing'
  get '' => 'pages#landing', as: :landing

  # landing page mailers
  post 'contact-us' => 'pages#contact_us', as: :contact_us
  post 'updates' => 'pages#updates', as: :updates

  # paper trail
  post 'versions/:id/revert' => 'versions#revert', :as => 'revert_version'
end
