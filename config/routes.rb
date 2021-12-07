Rails.application.routes.draw do
  get '/signup', to: 'users#new'
  resources :users
  # computers
  get '/computers', to: 'computers#index'
  get '/computers/:id', to: 'computers#show'
  post '/computers', to: 'computers#create'
  put '/computers/:id', to: 'computers#update'
  delete '/computers/:id', to: 'computers#destroy'

  # producers
  get '/producers', to: 'producers#index'
  get '/producers/:id', to: 'producers#show'
  post '/producers', to: 'producers#create'
  put '/producers/:id', to: 'producers#update'
  delete '/producers/:id', to: 'producers#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
