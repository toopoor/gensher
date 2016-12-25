class ChangeDefaultStateByPayments < ActiveRecord::Migration
  def change
    change_column_default :payments, :state, 'pending'
  end
end
