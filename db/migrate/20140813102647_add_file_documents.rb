class AddFileDocuments < ActiveRecord::Migration
  def up
    add_column :documents, :file, :string
  end

  def down
    remove_column :documents, :file
  end
end
