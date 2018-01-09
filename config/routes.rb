Rails.application.routes.draw do
  devise_for :users
  root 'pages#landing'
  get 'pages/landing'
end
