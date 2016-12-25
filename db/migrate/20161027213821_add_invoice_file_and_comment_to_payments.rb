class AddInvoiceFileAndCommentToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :invoice_file, :string
    add_column :payments, :comment, :text
  end
end
