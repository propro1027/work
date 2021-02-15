module SessionsHelper
  
  
  # ユーザーのブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成 ユーザーがブラウザを閉じた瞬間に無効となります）
  # userはインスタンス済み、DB上に登録済み  ユーザーIDを一時的セッションの中に安全に記
  # ユーザーのログインを行ってcreateアクションを完了して、ユーザー情報ページへリダイレクトする準備が整いました
   # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    # session[:user_id] = user.id
     session[:user_id] = user.id# .idだからuser ID??
  end
  
  
  # セッションと@current_userを破棄します
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  
  # ユーザーIDを別のページで安全に取り出すためのメソッド  「現在ログインしているユーザー」の値を取得できる
  def cuurent_user
    # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  
   # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def loged_in?
    # ログイン中のidは空っぽでなないよね？つまり、いるよね？
    !cuurent_user.nil?
  end






end