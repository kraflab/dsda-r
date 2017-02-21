Rails.application.routes.draw do
  root 'static_pages#home'
  get 'stats' => 'static_pages#stats'
  get 'tools' => 'static_pages#tools'
  get 'about' => 'static_pages#about'

  get    'login'    => 'sessions#new'
  post   'login'    => 'sessions#create'
  delete 'logout'   => 'sessions#destroy'
  get    'settings' => 'sessions#settings'
  patch  'settings' => 'sessions#set'
  
  get    'edit' => 'admins#edit'
  patch  'edit' => 'admins#update'
  
  get    'feed' => 'demos#feed'

  resources :players
  resources :iwads, except: [:edit, :update]
  resources :wads
  resources :ports, except: [:show, :edit, :update], :id => /([^\/])+/ do
    get :autocomplete_port_family, :on => :collection
  end
  resources :demos, except: [:index, :show]
end
