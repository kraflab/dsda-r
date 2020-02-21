Rails.application.routes.draw do
  root 'static_pages#home'
  get 'search' => 'static_pages#search'
  get 'stats'  => 'static_pages#stats'
  get 'about'  => 'static_pages#about'
  get 'rules'  => 'static_pages#intro'
  get 'intro'  => 'static_pages#intro'
  get 'changelog' => 'static_pages#changelog'
  get 'stream' => 'static_pages#stream'
  get 'advice' => 'static_pages#advice'

  get 'guides/crispy_doom' => 'guides#crispy_doom'
  get 'guides/prboom_plus' => 'guides#prboom_plus'

  get    'settings' => 'sessions#settings'
  patch  'settings' => 'sessions#set'

  get 'record_timeline'      => 'wads#record_timeline'
  get 'record_timeline_json' => 'wads#record_timeline_json'
  get 'compare_movies'      => 'wads#compare_movies'
  get 'compare_movies_json' => 'wads#compare_movies_json'

  get 'feed'         => 'demos#feed'
  get 'demos/:id/hidden_tag' => 'demos#hidden_tag'

  post 'api/demos/'   => "demos#api_create"
  patch 'api/demos/'  => "demos#api_update"
  post 'api/wads'     => "wads#api_create"
  post 'api/players/' => "players#api_create"
  post 'api/ports/'   => "ports#api_create"

  get 'api/demos/records' => 'demos#record'

  get 'no_file' => "static_pages#no_file"

  resources :players, only: [:show, :index] do
    get :autocomplete_player_username, :on => :collection
  end
  get 'players/:id/stats' => 'players#stats', as: 'player_stats'
  get 'players/:id/record_view' => 'players#record_view', as: 'player_record_view'

  resources :iwads, only: [:show, :index]
  get 'iwads/:id/stats' => 'iwads#stats', as: 'iwad_stats'

  resources :wads, only: [:show, :index]
  get 'wads/:id/stats' => 'wads#stats', as: 'wad_stats'
  get 'wads/:id/table_view' => 'wads#table_view', as: 'wad_table_view'
  get 'wads/:id/leaderboard' => 'wads#leaderboard', as: 'wad_leaderboard'

  resources :ports, only: [:index], :id => /([^\/])+/ do
    get :autocomplete_port_family, :on => :collection
  end
end
