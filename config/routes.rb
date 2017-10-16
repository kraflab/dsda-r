Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"

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

  get 'feed'         => 'demos#feed'
  get 'demos/:id/hidden_tag' => 'demos#hidden_tag'

  post 'api/demos/'   => "demos#api_create"
  post 'api/wads'     => "wads#api_create"
  post 'api/players/' => "players#api_create"
  post 'api/ports/'   => "ports#api_create"

  get 'no_file' => "static_pages#no_file"

  resources :players, only: [:show, :index] do
    get :autocomplete_player_username, :on => :collection
  end
  get 'players/:id/stats' => 'players#stats', as: 'player_stats'

  resources :iwads, only: [:show, :index]
  get 'iwads/:id/stats' => 'iwads#stats', as: 'iwad_stats'

  resources :wads, only: [:show, :index]
  get 'wads/:id/stats' => 'wads#stats', as: 'wad_stats'

  resources :ports, only: [:index], :id => /([^\/])+/ do
    get :autocomplete_port_family, :on => :collection
  end
end
