class ChangeDefaultStateByPursePayments < ActiveRecord::Migration
  def change
    change_column_default :purse_payments, :state, 'pending'
  end
end
