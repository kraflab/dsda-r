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
  
  get 'record_timeline' => 'wads#record_timeline'
  get 'record_timeline_json' => 'wads#record_timeline_json'
  
  get 'feed'   => 'demos#feed'
  get 'search' => 'static_pages#search'
  
  get 'category_filter' => 'sessions#category_filter'
  
  get 'api/wads/:query' => "wads#api_show", query: /[^\/]+/
  get 'api/players/:query' => "players#api_show", query: /[^\/]+/

  resources :players do
    get :autocomplete_player_username, :on => :collection
  end
  resources :iwads, except: [:edit, :update]
  resources :wads
  resources :ports, except: [:show, :edit, :update], :id => /([^\/])+/ do
    get :autocomplete_port_family, :on => :collection
  end
  resources :demos, except: [:index, :show]
end
