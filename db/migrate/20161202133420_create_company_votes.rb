class CreateCompanyVotes < ActiveRecord::Migration
  def change
    create_table :company_votes do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :company, index: true, foreign_key: true
      t.column(:vote, :decimal, precision: 4, scale: 2, default: 0)

      t.timestamps null: false
    end
  end
end
