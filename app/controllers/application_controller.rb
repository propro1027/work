class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  
  # グローバル変数はプログラムのどこからでも呼び出すことのできる変数で$変数名のように$を用いて表現
# %w{日 月 火 水 木 金 土}はRubyのリテラル表記と呼ばれるものです。
# ["日", "月", "火", "水", "木", "金", "土"]の配列と同じように使えます。
# ご覧の通り、"の記述が不要なので記述がとてもシンプルに済みますね。

  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
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
  
  
  
  
  
   # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date
    # @first_day = Date.current.beginning_of_month
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)


    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
       @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end
