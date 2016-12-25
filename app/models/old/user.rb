# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  login          :string(50)       default(""), not null
#  password       :string(32)       default(""), not null
#  salt           :string(3)        default(""), not null
#  fio            :string(250)      not null
#  fio_f          :string(64)       not null
#  fio_i          :string(64)       not null
#  fio_o          :string(64)       not null
#  email          :string(64)       not null
#  tel            :string(20)       not null
#  refer          :string(64)       not null
#  referid        :integer
#  referold       :integer          not null
#  skype          :string(30)       not null
#  key            :string(32)       not null
#  peper          :string(32)       not null
#  active         :boolean          default(FALSE), not null
#  logmetod       :boolean          not null
#  ip             :string(16)       not null
#  ip2            :string(32)       not null
#  compidreg      :integer          not null
#  datereg        :timestamp        not null
#  youtube        :string(64)       not null
#  gpl            :string(64)       not null
#  fb             :string(64)       not null
#  vk             :string(64)       not null
#  odkl           :string(64)       not null
#  mailru         :string(64)       not null
#  pay_metodx     :string(1000)     not null
#  foto           :string(250)      not null
#  country        :string(30)       not null
#  city           :string(30)       not null
#  about_me       :string(2040)     not null
#  steps          :boolean          not null
#  vktool         :boolean          not null
#  ban            :boolean          not null
#  r_buy          :integer          not null
#  r_self         :integer          not null
#  r_num          :integer          not null
#  deleted_at     :datetime
#  user_id        :integer
#  lft            :integer
#  rgt            :integer
#  depth          :integer
#  children_count :integer
#

class Old::User < OldBase
  TYPES = %w(all by_import without_email without_phone completed)
  PUBLIC_ATTRS = [:fio_f, :fio_i, :fio_o, :email, :tel, :skype]

  acts_as_paranoid
  acts_as_nested_set parent_column: :referid, dependent: :destroy

  belongs_to :user, class_name: '::User'
  has_many :tariffs, class_name: 'Old::Tariff', foreign_key: :userid
  has_one :pay_tariff, -> { where tarif: true, status: true }, class_name: 'Old::Tariff', foreign_key: :userid

  scope :not_completed, -> { where(user_id: nil) }
  scope :completed,     -> { joins(:user) }
  scope :with_email,    -> { where.not(email: '') }
  scope :with_skype,    -> { where.not(skype: '') }
  scope :with_phone,    -> { where.not(tel: '') }
  scope :publish,       -> { not_completed.where('users.email <> :s or users.tel <> :s', s: '') }
  scope :pay,           -> { joins(:pay_tariff) }
  scope :active,        -> { joins(:tariffs) }
  scope :nested_set,    -> { active.order('lft ASC')  }
  scope :reversed_nested_set, -> { active.order('lft DESC') }

  scope :by_import,     -> { not_completed.with_email.with_phone.with_skype }
  scope :without_email, -> { not_completed.with_phone.where(email: '') }
  scope :without_phone, -> { not_completed.with_email.where(tel: '') }

  def active?
    self.tariffs.present?
  end

  def imported?
    self.email.present? && self.tel.present? && self.skype.present?
  end

  def completed?
    self.user.present?
  end

  def to_user(parent)
    user = parent.children.build(email: self.email.presence, phone: self.tel.presence)
    user.password = Devise.friendly_token[0,20]

    user.first_name = self.fio_f
    user.last_name = self.fio_i
    user.middle_name = self.fio_o
    user.username = self.login

    user.skype = self.skype
    user.skip_confirmation!
    if user.valid?
      user.send_reset_password_instructions
      self.user = user
      self.save
      self.children.active.uniq.map{|child| child.to_user(user)}
    end
  end

  private
  def is_imported
    errors.add(:base, :not_imported) unless self.imported?
  end
end
