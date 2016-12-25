class CreatePurses < ActiveRecord::Migration
  def change
    create_table :purses do |t|
      t.integer :amount_cents

      t.timestamps
    end
  end
end
