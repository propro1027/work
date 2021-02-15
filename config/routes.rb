Rails.application.routes.draw do
  root 'static_page#home'
  get '/new', to:'users#new'
  
  # ログインページ sessions
  get '/login', to:'sessions#new'
  post   '/login', to: 'sessions#create' 
  delete '/logout', to:'sessions#destroy' 
  
  
  resources :users
end
