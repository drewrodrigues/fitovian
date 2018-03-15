Rails.application.routes.draw do
  get 'plan/new'

  get 'plan/edit'

  get 'plan/create'

  get 'plan/update'

  # REVIEW: do I have to do as on all of them? What are the automated ones?
  get 'billing' => 'billing#new', as: :new_payment_method
  get 'dashboard' => 'billing#dashboard', as: :billing_dashboard
  put 'billing/re_activate' => 'billing#re_activate', as: :re_activate
  put 'billing/update' => 'billing#update', as: :update_payment_method
  post 'billing/subscribe/:stripe_token' => 'billing#subscribe', as: :subscribe
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
