Rails.application.routes.draw do
  root 'static_pages#home'
  get 'search' => 'static_pages#search'
  get 'stats'  => 'static_pages#stats'
  get 'about'  => 'static_pages#about'

  get    'login'    => 'sessions#new'
  post   'login'    => 'sessions#create'
  delete 'logout'   => 'sessions#destroy'
  get    'settings' => 'sessions#settings'
  patch  'settings' => 'sessions#set'

  get    'edit' => 'admins#edit'
  patch  'edit' => 'admins#update'

  get 'record_timeline'      => 'wads#record_timeline'
  get 'record_timeline_json' => 'wads#record_timeline_json'
  get 'compare_movies'      => 'wads#compare_movies'
  get 'compare_movies_json' => 'wads#compare_movies_json'

  get 'demos/latest' => "demos#latest"
  get 'feed'         => 'demos#feed'
  get 'demos/:id/hidden_tag' => 'demos#hidden_tag'

  get 'category_filter' => 'sessions#category_filter'

  get  'api/wads/'    => "wads#api_show"
  get  'api/players/' => "players#api_show"
  post 'api/demos/'   => "demos#api_create"
  post 'api/wads'     => "wads#api_create"
  post 'api/players/' => "players#api_create"

  get 'no_file' => "static_pages#no_file"

  resources :players do
    get :autocomplete_player_username, :on => :collection
  end
  get 'players/:id/stats' => 'players#stats', as: 'player_stats'

  resources :iwads, except: [:edit, :update]
  get 'iwads/:id/stats' => 'iwads#stats', as: 'iwad_stats'

  resources :wads
  get 'wads/:id/stats' => 'wads#stats', as: 'wad_stats'

  resources :ports, except: [:show, :edit, :update], :id => /([^\/])+/ do
    get :autocomplete_port_family, :on => :collection
  end

  resources :demos, except: [:index, :show]
end
