class AddUserIdToMessage < ActiveRecord::Migration
  def up
    add_column :messages, :user_id, :integer
  end

  def down
    remove_column :messages, :user_id, :integer
  end
end
