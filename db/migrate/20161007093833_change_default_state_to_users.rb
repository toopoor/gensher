class ChangeDefaultStateToUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :state, 'pending'
  end
end
