class AddRemnberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :remnber, :string
  end
end
