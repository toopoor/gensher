class CreateInformes < ActiveRecord::Migration
  def change
    create_table :informes do |t|
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
