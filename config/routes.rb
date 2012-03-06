Doomhub::Application.routes.draw do
  
  root :to => 'home#index'

  resources :projects do
    resources :maps do
      resources :map_wadfiles do
        member do
          get :download
        end
      end
    end
  end

  devise_for :users

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
    get "/register" => "devise/registrations#new"
    get "/edit_profile" => "devise/registrations#edit"
  end

  get "home/index"
end