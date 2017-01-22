Rails.application.routes.draw do
  get 'sessions/new'

  get 'users/new'

  root 'static_pages#home'

  get '/help', to: 'static_pages#help', as: 'help'
  
  get '/about', to: 'static_pages#about', as: 'about'
  
  get '/contact', to: 'static_pages#contact'
  
  get '/signup', to: 'users#new', as: 'signup'
  
  get '/login', to: 'sessions#new'
  
  post '/login', to: 'sessions#create'
  
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
