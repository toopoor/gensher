# class PurseStub < ActiveRecord::Base
#   self.table_name = 'purses'
#   monetize :amount_cents#, as: :amount
# end

class UserStub < ActiveRecord::Base
  self.table_name = 'users'
  belongs_to :purse, class_name: 'PurseStub', foreign_key: :purse_id

  def create_purse
    self.purse = PurseStub.create!(amount:0) if self.purse.blank?
    self.save!
  end
end

class AddPurseIdToUsers < ActiveRecord::Migration
  def migrate(direction)
    super
    UserStub.find_each(&:create_purse) if direction == :up
  end

  def change
    add_reference :users, :purse, index: true
  end
end
