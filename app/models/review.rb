class Review < ActiveRecord::Base
  belongs_to :author, class_name: 'User'

  scope :moderated, -> { where(moderated: true) }
  scope :ordered,   -> { order(created_at: :desc) }
  scope :by_landing, -> { moderated.ordered.limit(5) }
end
