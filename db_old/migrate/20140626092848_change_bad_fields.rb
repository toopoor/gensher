class ChangeBadFields < ActiveRecord::Migration
  def change
    rename_column :collage,     :type, :collage_type
    rename_column :list_events, :type, :event_type
  end
end
