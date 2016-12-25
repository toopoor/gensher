class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.belongs_to :user, index: true
      t.string :provider
      t.string :uid
      t.string :token
      t.datetime :expires_at
      t.string :url

      t.timestamps
    end
    add_index :authentications, :provider
    add_index :authentications, :uid
    add_index :authentications, [:provider, :uid]
    add_index :authentications, :token
  end
end
