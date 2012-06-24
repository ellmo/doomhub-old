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

  devise_for :user, :path => '', :path_names => {
    :sign_in => "login",
    :sign_out => "logout",
    :sign_up => "new",
    :registration => 'registration'
  }

  get "home/index"

end