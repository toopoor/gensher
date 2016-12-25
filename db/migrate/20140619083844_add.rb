class Add < ActiveRecord::Migration
  def up
    # free plan as default
    add_column :users, :plan, :integer, default: 1
  end

  def down
    remove_column :users, :plan
  end
end
