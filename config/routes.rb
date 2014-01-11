Doomhub::Application.routes.draw do

  root :to => 'news#index'

  get "/p/:id/m" => redirect("/p/%{id}#maps")
  get "/p/:project_id/m/:id/f" => redirect("/p/%{project_id}/m/%{id}#files")
  get "/p/:project_id/m/:id/i" => redirect("/p/%{project_id}/m/%{id}#images")

  resources :projects, :path => '/p' do
    resources :file_links, path: '/l', except: [:index]
    resources :comments, :path => '/c', except: [:edit]
    resources :resources, :path => '/r', only: [:new, :index]
    resources :maps, :path => '/m', :except => [:index] do
      resources :uploads, :path => '/f', :except => [:index] do
        member { get :download }
      end
      resources :map_images, :path => '/i', :except => [:index] do
        member { get :auth_url }
      end
      resources :file_links, path: '/l', except: [:index]
      resources :resources, :path => '/r', only: [:new, :index]
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