# encoding: utf-8
# -*- coding: utf-8 -*-
class PurseStub < ActiveRecord::Base
  self.table_name = 'purses'
  monetize :amount_cents,  as: :amount
end

class SystemAccountStub < ActiveRecord::Base
  self.table_name = 'system_accounts'
  belongs_to :purse, class_name: 'PurseStub', foreign_key: :purse_id

  before_create :create_purse

  def create_purse
    self.purse = PurseStub.create!(amount:0) if self.purse.blank?
  end
end

class CreateSystemAccounts < ActiveRecord::Migration
  def migrate(direction)
    super
    SystemAccountStub.create!(identifier: 'gensherman', name: 'Системный Счет General Sherman') if direction == :up
  end

  def change
    create_table :system_accounts do |t|
      t.string :name
      t.string :identifier
      t.belongs_to :purse, index: true

      t.timestamps
    end
  end
end
