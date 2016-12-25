class CompanyVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  scope :by_user, ->(user){ where(user_id: user.id) }
  after_create :calculate_company_rating!

  validates :user_id, uniqueness: {scope: :company_id}

  protected
  def calculate_company_rating!
    self.company.send(:calculate_rating!)
  end
end
