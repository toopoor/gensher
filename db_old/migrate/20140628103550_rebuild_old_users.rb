class RebuildOldUsers < ActiveRecord::Migration
  def up
    change_column :users, :referid, :integer, null: true
    Old::User.where(referid: 0).update_all(referid: nil)
    Old::User.rebuild!
  end

  def down
    change_column :users, :referid, :integer, null: false
  end
end
