module SessionsHelper
  
  
  # ユーザーのブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成 ユーザーがブラウザを閉じた瞬間に無効となります）
  # userはインスタンス済み、DB上に登録済み  ユーザーIDを一時的セッションの中に安全に記
  # ユーザーのログインを行ってcreateアクションを完了して、ユーザー情報ページへリダイレクトする準備が整いました
   # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    # session[:user_id] = user.id
     session[:user_id] = user.id# .idだからuser ID??
  end
  
   # 永続的セッションを記憶（Userモデルを参照） 
  def remember(user)
    user.remember
    # cookiesをブラウザに保存する前に署名付きで安全に暗号化する
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end


  # 永続的セッションを破棄します
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  

  # セッションと@current_userを破棄します
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  
  # ユーザーIDを別のページで安全に取り出すためのメソッド  「現在ログインしているユーザー」の値を取得できる
  # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
   # 一時的セッションにいるユーザーを返します。
  # それ以外の場合はcookiesに対応するユーザーを返します。
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
   # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def loged_in?
    # ログイン中のidは空っぽでなないよね？つまり、いるよね？
    !current_user.nil?
  end

 



end