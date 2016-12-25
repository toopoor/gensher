# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  message_type :string(255)
#  subject      :string(255)
#  body         :text
#  is_active    :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :integer
#

class Message < ActiveRecord::Base
  TYPES = %w(support feedback news news_system conference).freeze
  default_scope { order('messages.id desc') }
  belongs_to :user

  include PublicActivity::Model
  tracked except: :destroy, on: {
    update: proc { |model| model.feedback? && model.is_active? },
    create: proc { |model| model.news? }
  }

  validates_inclusion_of :message_type, in: TYPES
  validates_presence_of :subject

  scope :active, -> { where(is_active: true) }
  scope :public_feedback, -> { message_type('feedback').active }
  scope :message_type, ->(type) { where(message_type: type) }
  scope :sysnews, -> { message_type('news_system') }
  scope :conference, -> { message_type('conference') }
  scope :my, ->(u) { where('messages.user_id IN (?)', [u.id, u.parent_id]) }
  scope :mynews, ->(u) { message_type('news').my(u) }

  after_create :check_email_notification

  def feedback?
    message_type.eql?('feedback')
  end

  def support?
    message_type.eql?('support')
  end

  def news?
    message_type.eql?('news')
  end

  def check_email_notification
    ContactMailer.feedback(self).deliver if feedback? || support?

    return unless news?
    User.first_line(user).each do |user|
      ContactMailer.sponsor_news(self, user).deliver
    end
  end

  def can_edit?(user)
    return false unless user
    return false if feedback? && !user.admin?

    user.admin? || user_id.eql?(user.id)
  end
end
