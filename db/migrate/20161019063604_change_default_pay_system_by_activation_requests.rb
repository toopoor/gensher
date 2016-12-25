class ChangeDefaultPaySystemByActivationRequests < ActiveRecord::Migration
  def change
    change_column_default :activation_requests, :pay_system, 'advcash'
  end
end
