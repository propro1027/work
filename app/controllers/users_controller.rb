class UsersController < ApplicationController
  
  
  def show
    # ユーザーid取得でparams
    @user = User.find(params[:id])
  end

  def new
     @user = User.new # 新規ユーザー作成画面
  end
  
  # 新規ユーザー作成後の個人画面
  def create
    @user = User.new(key)
    # リダイレクトしてユーザー情報ページへ遷移する。
    if @user.save
      log_in @user # 保存成功後、ログインします。
      flash.now[:success] = '新規作成成功'
      # showのviewへ飛ぶ
      redirect_to @user
    else
      render:new
    end
  end
  
  # params_userメソッドはUsersコントローラーの内部でのみ実行
  private
    def key
      #:userキー
      params.require(:user).permit(:name, :email, :belong, :password, :password_confimation)
    end
    
    
end
