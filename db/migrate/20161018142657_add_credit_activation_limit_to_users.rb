class AddCreditActivationLimitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit_activation_limit, :integer, default: 0
  end
end
