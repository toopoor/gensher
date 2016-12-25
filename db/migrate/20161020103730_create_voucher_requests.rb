class CreateVoucherRequests < ActiveRecord::Migration
  def change
    create_table :voucher_requests do |t|
      t.belongs_to :owner, index: true
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :voucher, index: true, foreign_key: true
      t.string :state, default: 'pending'
      t.datetime :activated_at
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
