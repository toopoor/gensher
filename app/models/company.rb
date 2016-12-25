class Company < ActiveRecord::Base
  belongs_to :user
  has_many :company_votes

  mount_uploader :logo, CompanyLogoUploader

  scope :moderated_by_user, ->(user){ where('moderated = true or user_id = ?', user.id) }
  scope :by_user,           ->(user){ where(user_id: user.id) }
  scope :ordered,           ->{ order(rating: :desc) }


  def can_update?(u)
    u.admin? || (self.user.eql?(u) && !self.moderated?)
  end

  protected
  def calculate_rating!
    self.update(rating: self.company_votes.sum(:vote)/self.company_votes.count)
  end
end
