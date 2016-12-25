class CreateActivationRequests < ActiveRecord::Migration
  def change
    create_table :activation_requests do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :admin, index: true
      t.belongs_to :system_deposit, index: true
      t.belongs_to :parent_deposit, index: true
      t.string :state, default: 'pending'
      t.string :system_invoice_file
      t.string :parent_invoice_file
      t.boolean :system, default: true

      t.timestamps null: false
    end
  end
end
