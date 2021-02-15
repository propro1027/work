class AddIndexUsersEmail < ActiveRecord::Migration[5.1]
  def change
    # email属性にインデックスを追加
    add_index :users, :email, unique:true
  end
end
