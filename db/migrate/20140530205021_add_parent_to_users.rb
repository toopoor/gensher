class AddParentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :parent_id, :integer
    add_index :users, :parent_id
    add_column :users, :lft, :integer
    add_column :users, :rgt, :integer
    add_column :users, :children_count, :integer
  end
end
