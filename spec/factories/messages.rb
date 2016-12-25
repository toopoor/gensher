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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    type ""
    subjet "MyString"
    body "MyText"
    is_active false
  end
end
