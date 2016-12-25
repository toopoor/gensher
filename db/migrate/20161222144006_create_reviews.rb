class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.belongs_to :author, index: true
      t.boolean :moderated, default: false
      t.text :body

      t.timestamps null: false
    end
  end
end
