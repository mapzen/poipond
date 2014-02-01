Poipond::Application.routes.draw do

  root 'home#index', as: 'home'

  get '/signup' => 'users#new', as: :signup
  post '/users/create' => 'users#create', as: :create_user
  get '/auth/:provider/callback' => 'sessions#create'
  post '/sessions/create' => 'sessions#create', as: :login
  get '/logout' => 'sessions#destroy', as: :logout

  resources :pois
  get '/pois/new/choose_category(/:category_id)' => 'pois#choose_category', as: :choose_category
  get '/pois/new/choose_location/:category_id' => 'pois#choose_location', as: :choose_location

  get '/api/v0/pois/closest' => 'api/v0/pois#closest', :defaults => { :format => "json" }

end
