Rails.application.routes.draw do
  # resources :producers
  get '/producers', to: 'producers#index'
  get '/producers/:id', to: 'producers#show'
  post '/producers', to: 'producers#create'
  put '/producers/:id', to: 'producers#update'
  delete '/producers/:id', to: 'producers#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
