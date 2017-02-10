Rails.application.routes.draw do
  root 'static_pages#home'
  get 'stats' => 'static_pages#stats'
  get 'tools' => 'static_pages#tools'

  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  get    'edit' => 'admins#edit'
  patch  'edit' => 'admins#update'

  resources :players
  resources :iwads
  resources :wads
  resources :ports, except: :show, :id => /([^\/])+/ do
    get :autocomplete_port_family, :on => :collection
  end
end
