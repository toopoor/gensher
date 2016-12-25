class CreatePursePayments < ActiveRecord::Migration
  def change
    create_table :purse_payments do |t|
      t.string :type
      t.belongs_to :source_purse, index: true
      t.belongs_to :purse, index: true
      t.belongs_to :source_payment, index: true
      t.references :target, polymorphic: true, index: true
      t.string :name
      t.text :description
      t.integer :amount_cents, default: 0, null: false
      t.string :state, index: true
      t.text :params

      t.timestamps
    end
    add_index :purse_payments, :type
  end
end
