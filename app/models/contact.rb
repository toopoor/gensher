# app/models/contact.rb
class Contact
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  include ActiveModel::Validations

  # Validation
  validates :name, presence: true
  validates :email, format: { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
  validates :message, presence: true, length: { maximum: 1000 }

  attr_accessor :name, :email, :message, :phone

  def deliver
    return false unless valid?
    ContactMailer.notify(self).deliver
  end
end
