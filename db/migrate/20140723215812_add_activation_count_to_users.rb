class AddActivationCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_count, :integer, default: 0
    add_index :users, :activation_count
  end
end
