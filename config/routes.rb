Doomhub::Application.routes.draw do

  root :to => 'news#index'

  get "/p/:id/m" => redirect("/p/%{id}#maps")
  get "/p/:project_id/m/:id/w" => redirect("/p/%{project_id}/m/%{id}#wadfiles")
  get "/p/:project_id/m/:id/i" => redirect("/p/%{project_id}/m/%{id}#images")

  resources :projects, :path => '/p' do
    resources :comments, :path => '/c', :provides => [:json, :xml]
    resources :maps, :path => '/m', :except => [:index] do
      resources :map_wadfiles, :path => '/w', :except => [:index] do
        member do
          get :download
        end
      end
      resources :map_images, :path => '/i', :except => [:index] do
        member do
          get :auth_url
        end
      end
    end
  end

  resources :news, :path => '/n'

  resources :users, :path => '/u', :only => [:show, :index] do
    resources :projects, :path => '/p'
  end

  devise_for :user, :path => '', :path_names => {
    :sign_in => "login",
    :sign_out => "logout",
    :sign_up => "new",
    :registration => 'registration'
  }

end