Poipond::Application.routes.draw do

  root 'home#index', as: 'home'

  get '/signup' => 'users#new', as: :signup
  post '/users/create' => 'users#create', as: :create_user
  get '/auth/:provider/callback' => 'sessions#create'
  post '/sessions/create' => 'sessions#create', as: :login
  get '/logout' => 'sessions#destroy', as: :logout

  # api
  post '/api/v0/pois/create' => 'api/v0/pois#create'
  post '/api/v0/pois/:id' => 'api/v0/pois#update'
  get '/api/v0/pois/closest' => 'api/v0/pois#closest', :defaults => { :format => "json" }
  get '/api/v0/pois/:id' => 'api/v0/pois#show', :defaults => { :format => "json" }

end
