# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  invitations_count      :integer          default(0)
#  phone                  :string(255)
#  parent_id              :integer
#  lft                    :integer
#  rgt                    :integer
#  children_count         :integer
#  token                  :string(255)
#  purse_id               :integer
#  role                   :string(255)      default("user"), not null
#  avatar                 :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  middle_name            :string(255)
#  skype                  :string(255)
#  address                :text
#  username               :string(255)
#  state                  :string(255)
#  avatar_meta            :text
#  plan                   :integer          default(1)
#  activation_count       :integer          default(0)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  end
end
