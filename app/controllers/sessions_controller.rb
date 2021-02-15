class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
       log_in(user) #ヘルパーメソッドに飛ぶ
       remember(user)
       redirect_to(user)#ユーザー情報ページに飛ぶ
    else
      # layouts/application.html.erbで場合わけのカーラー
     flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  
  def destroy
    log_out if loged_in?
    flash.now[:success] = "ログアウトしました"
    redirect_to root_url
  end
  
  
end
