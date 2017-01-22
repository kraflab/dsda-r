Rails.application.routes.draw do
  get 'players/new'

  get 'player/new'

  root 'static_pages#home'
  
  get 'home' => 'static_pages#home'
end
