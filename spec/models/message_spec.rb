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

require 'spec_helper'

describe Message do
  pending "add some examples to (or delete) #{__FILE__}"
end
