class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :type
      t.belongs_to :user, index: true
      t.integer :amount_cents, default: 0, null: false
      t.string :currency, default: 'USD'
      t.string :token
      t.string :identifier
      t.string :payer_id
      t.string :state

      t.timestamps
    end
    add_index :payments, :type
    add_index :payments, :currency
    add_index :payments, :token
    add_index :payments, :identifier
    add_index :payments, :state
  end
end
