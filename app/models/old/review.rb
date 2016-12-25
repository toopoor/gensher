# == Schema Information
#
# Table name: reviews
#
#  id      :integer          not null, primary key
#  userid  :integer          not null
#  content :string(2040)     not null
#  publ    :boolean          not null
#  mod     :boolean          not null
#  date    :timestamp        not null
#

class Old::Review < OldBase
  belongs_to :user, class_name: 'Old::User', foreign_key: :userid

  scope :published, -> { where(publ: true) }

end
