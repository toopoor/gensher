class LandingContact < ActiveRecord::Base
  belongs_to :partner, class_name: 'User'
  validates :name, :email, :message, presence: true
end
