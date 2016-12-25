# == Schema Information
#
# Table name: system_accounts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  identifier :string(255)
#  purse_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class SystemAccount < ActiveRecord::Base
  belongs_to :purse

  delegate :amount, to: :purse

  before_create :create_purse

  class << self
    def total_amount
      self.all.sum(&:amount)
    end

    def gensherman
      self.find_by(identifier: 'gensherman')
    end
  end

  protected
  def create_purse
    self.purse = Purse.create!(amount:0) if self.purse.blank?
  end
end
