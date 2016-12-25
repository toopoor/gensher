class AddCommentAndPaySystemToActivationRequests < ActiveRecord::Migration
  def change
    add_column :activation_requests, :pay_system, :string, default: 'payeer'
    add_column :activation_requests, :comment, :text
  end
end
