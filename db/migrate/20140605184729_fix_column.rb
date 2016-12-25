class FixColumn < ActiveRecord::Migration
  def up
    rename_column :messages, :subjet, :subject
  end

  def down
    rename_column :messages, :subject, :subjet
  end
end
