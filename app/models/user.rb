class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :belong, presence: true
  
  # トークン作成-------------------------
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。Rubyの標準ライブラリSecureRandomモジュール
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
 
  attr_accessor :remember_token
  # ハッシュ化したトークンをデータベースに記憶
  def remember
    # selfで仮想のremember_token属性にUser.new_tokenで生成した「ハッシュ化されたトークン情報」を代入
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
   # トークンがダイジェストと一致すればtrueを返します
  # cookiesに保存されているremember_tokenがデータベースにあるremember_digestと一致することを確認します。（トークン認証）
 def authenticated?(remember_token)
  # ダイジェストが存在しない場合はfalseを返して終了します。
  return false if remember_digest.nil?
  BCrypt::Password.new(remember_digest).is_password?(remember_token)
 end
  
  
    # ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end

end
