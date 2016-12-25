class AddNestedSetAttrToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lft, :integer
    add_column :users, :rgt, :integer
    add_column :users, :depth, :integer
  end
end
