class CreateLandingContacts < ActiveRecord::Migration
  def change
    create_table :landing_contacts do |t|
      t.belongs_to :partner, index: true
      t.string :name
      t.string :email
      t.string :phone
      t.string :address
      t.string :ip_address
      t.boolean :read, default: false
      t.text :message

      t.timestamps null: false
    end
  end
end
