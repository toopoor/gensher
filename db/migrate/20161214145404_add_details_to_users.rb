class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :about_me, :text
    add_column :users, :success_story, :text
  end
end
