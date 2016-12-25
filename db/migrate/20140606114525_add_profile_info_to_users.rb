class AddProfileInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :middle_name, :string
    add_column :users, :skype, :string
    add_column :users, :address, :text
  end
end
