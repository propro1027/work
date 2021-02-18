class UsersController < ApplicationController
  
  # 指定のアクションが実行される直前に走るプログラムを記述することができます
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :owner_account, only: :destroy
  
  
  # ユーザー一覧　インスタンス変数名は全てのユーザーを代入した複数形であるため@usersとしています。
  def index
    # @users = User.all
    # ページネーション対応
    @users = User.paginate(page: params[:page])
  end
  
  
  def show
    # ユーザーid取得でparams
    # @user = User.find(params[:id])   before_actionで事前に走らせているので省略
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
  
  def edit 
    # @user = User.find(params[:id])
  end
  
  
  def update
    # @user = User.find(params[:id])
     if @user.update_attributes(key)
       flash[:success] = "ユーザー情報を更新しました。"
       redirect_to @user
     else
       render:edit
     end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  
  # params_userメソッドはUsersコントローラーの内部でのみ実行
  private
    def key
      #:userキー
      params.require(:user).permit(:name, :email, :belong, :password, :password_confimation)
    end

# beforeフィルター
# 以下セキュリティーモデル

# paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end
    
    # 1 ログイン済みのユーザーか確認します。まずは「ユーザーにログインを要求する」セキュリティモデルを追加
    def logged_in_user
    # sessinon helper
     unless loged_in?
       store_location
       flash[:danger] = "ログインしてください。"
       redirect_to login_url
     end
    end
    
    # # 2 ユーザー自身のみが情報を編集・更新可能
    # def correct_user
    #   # アクセスしたユーザーを判定
    #   @user = User.find(params[:id])
    #   redirect_to(root_url) unless @user == current_user
    # end
    
     # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end
    
     # システム管理権限所有かどうか判定。
    def owner_account
      redirect_to root_url unless current_user.owner?
    end
    
    
end
