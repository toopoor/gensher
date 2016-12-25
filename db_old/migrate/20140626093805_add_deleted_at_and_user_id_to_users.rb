class AddDeletedAtAndUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime
    add_index  :users, :deleted_at
    add_column :users, :user_id, :integer
    add_index  :users, :user_id
  end
end
