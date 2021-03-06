class Attendance < ApplicationRecord
  # Userモデルと1対1の関係
  belongs_to :user
  
  validates :worked_on, presence:true
  validates :note, length: { maximum: 50 }
  
  # 出勤時間が存在しない場合、退勤時間は無効  バリデーションメソッド名を指すシンボルを渡しvalidateクラスメソッドを使って登録
  validate :finished_at_is_invalid_without_a_started_at
 
  
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  
  
  
  # add
  # 出勤のみしかない時存在する時、編集エラー
  validate :started_only_error
  
  
  # original
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
 
  
  
  
  # add
  def started_only_error
   errors.add(:finished_at, "が必要です") if started_at.present? && finished_at.blank?
  end
  
  
  
 
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
 
  
  
end


 
  