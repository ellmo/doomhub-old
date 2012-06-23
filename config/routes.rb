Doomhub::Application.routes.draw do

  root :to => 'home#index'

  get "/projects/:id/maps" => redirect("/projects/%{id}#maps")
  get "/projects/:project_id/maps/:id/wadfiles" => redirect("/projects/%{project_id}/maps/%{id}#wadfiles")

  resources :projects do
    resources :maps, :except => [:index] do
      resources :map_wadfiles, :except => [:index] do
        member do
          get :download
        end
      end
    end
  end

  resources :users, :only => [:show, :index] do
    resources :projects
  end


  devise_for :users, :skip => [:sessions]
  as :user do
    get '/login' => 'devise/sessions#new', :as => :new_user_session
    post '/register' => 'devise/sessions#create', :as => :user_session
    delete '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # devise_scope :user do
  #   get "/login" => "devise/sessions#new"
  #   delete "/logout" => "devise/sessions#destroy"
  #   get "/register" => "devise/registrations#new"
  #   get "/edit_profile" => "devise/registrations#edit"
  # end

  get "home/index"
end