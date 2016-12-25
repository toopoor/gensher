class AddLendingTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lending_type, :string, default: 'one'
    add_index  :users, :lending_type
  end
end
