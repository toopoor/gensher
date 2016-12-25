# == Schema Information
#
# Table name: informes
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Informe < ActiveRecord::Base
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create

  before_create :init_token

  def init_token
    self.token = UUID.new.generate
  end
end
