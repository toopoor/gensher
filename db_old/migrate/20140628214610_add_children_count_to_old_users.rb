class AddChildrenCountToOldUsers < ActiveRecord::Migration
  def change
    add_column :users, :children_count, :integer
    reversible do |dir|
      dir.up do
        Old::User.active.find_each{|u| u.update_attribute(:children_count, u.children.count)}
      end
    end
  end
end
