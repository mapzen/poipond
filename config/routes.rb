Poipond::Application.routes.draw do

  root 'home#index', as: 'home'

  get '/signup' => 'users#new', as: :signup
  post '/users/create' => 'users#create', as: :create_user

  get '/auth/:provider/callback' => 'sessions#create'
  post '/sessions/create' => 'sessions#create', as: :login
  get '/logout' => 'sessions#destroy', as: :logout

  get '/pois/:osm_id' => 'pois#show', as: :poi
  get '/pois/new' => 'pois#new', as: :new_poi
  post '/pois/create' => 'pois#create', as: :create_poi

end
