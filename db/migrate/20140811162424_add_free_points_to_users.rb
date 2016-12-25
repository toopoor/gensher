class AddFreePointsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :free_points, :integer
    add_index :users, :free_points
  end
end
