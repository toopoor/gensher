class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :message_type
      t.string :subjet
      t.text :body
      t.boolean :is_active

      t.timestamps
    end
  end
end
