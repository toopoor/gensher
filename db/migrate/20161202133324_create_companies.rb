class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :name
      t.string :logo
      t.text :description
      t.string :video_url
      t.text :marketing
      t.column(:rating, :decimal, precision: 4, scale: 2, default: 0)
      t.boolean :moderated, default: false

      t.timestamps null: false
    end
  end
end
