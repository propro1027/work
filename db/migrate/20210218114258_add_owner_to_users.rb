class AddOwnerToUsers < ActiveRecord::Migration[5.1]
  
  # 管理者権限
  def change
    add_column :users, :owner, :boolean
  end
end
