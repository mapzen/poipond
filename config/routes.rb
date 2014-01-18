Poipond::Application.routes.draw do

  root 'home#index', as: 'home'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signup' => 'users#new', as: :signup
  post '/users/create' => 'users#create', as: :create_user
  post '/sessions/create' => 'sessions#create', as: :login
  get '/logout' => 'sessions#destroy', as: :logout

end
