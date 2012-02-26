Doomhub::Application.routes.draw do

  root :to => 'home#index'

  resources :projects

  devise_for :users

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
    get "/register" => "devise/registrations#new"
  end

  get "home/index"

end