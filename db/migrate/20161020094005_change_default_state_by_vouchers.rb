class ChangeDefaultStateByVouchers < ActiveRecord::Migration
  def change
    change_column_default :vouchers, :state, 'pending'
  end
end
