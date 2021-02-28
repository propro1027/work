Rails.application.routes.draw do
  root 'static_page#home'
  get '/new', to:'users#new'
  
  # ログインページ sessions
  get '/login', to:'sessions#new'
  post   '/login', to: 'sessions#create' 
  delete '/logout', to:'sessions#destroy' 
  
  
  # resources :users
  # モーダルウィンドウ
  resources :users do
    member do
     get 'edit_basic_info'
    patch 'update_basic_info'
    get 'attendances/edit_one_month' # 勤怠情報編集
     patch 'attendances/update_one_month' # 勤怠編集更新
    end
    
    resources :attendances, only: :update
    
    
  end
end
