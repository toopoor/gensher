class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.string :type
      t.belongs_to :owner, index: true
      t.belongs_to :user, index: true
      t.integer :amount_cents
      t.string :state

      t.timestamps
    end
    add_index :vouchers, :type
    add_index :vouchers, :state
  end
end
