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

class User < ActiveRecord::Base
  include TheSortableTree::Scopes
  include PublicActivity::Model
  include OmniauthConcern
  include PlansConcern
  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable

  has_many :messages
  has_many :documents
  has_many :invitations, class_name: 'User', as: :invited_by
  has_one :old_user, class_name: 'Old::User'

  attr_accessor :login, :parent_token
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  extend CarrierWave::Meta::ActiveRecord
  serialize :avatar_meta, OpenStruct
  mount_uploader :avatar, AvatarUploader
  carrierwave_meta_composed :avatar_meta, :avatar, :avatar_source,
                            :avatar_source_thumb, :avatar_source_icon

  acts_as_nested_set counter_cache: :children_count

  attr_writer :login

  # Monetize
  belongs_to :purse
  has_many :payment_cash_deposits, class_name: 'Payment::CashDeposit'
  has_many :payment_cash_withdrawals, class_name: 'Payment::CashWithdrawal'

  before_create :create_purse

  before_create :generate_token
  # before_create :invited_by_free
  after_update :recreate_avatar_versions!, if: :cropping?

  # before_invitation_accepted :invited_by_free
  # after_invitation_accepted :add_free_points

  validates :phone, presence: true, uniqueness: { if: :not_dummy_phone? }
  validates :skype, presence: true
  validate :has_parent, on: :create
  validates :username, allow_blank: true, uniqueness: true

  scope :first_line,       ->(user) { where(parent_id: user.id) }
  scope :inactive_invited, ->(user) { pending.where(invited_by_id: user.id) }
  scope :by_credit,        -> { where(state: 'accumulate') }
  scope :pending,          -> { where(state: 'pending') }
  scope :activated,        -> { where(state: 'activated') }
  scope :real_team,        -> { where(state: %w(activated completed)) }
  scope :admins,           -> { where(role: 'admin') }
  scope :ordered,          -> { order(created_at: :desc, state: :desc) }
  scope :recent,           -> { where('created_at > ?', Time.current - 2.days) }
  scope :in_progress,      -> { joins(:activation_request).where(state: %w(pending accumulate))}
  scope :has_money,        -> { joins(:purse).where('purses.amount_cents > 0') }

  delegate :purse_payments, to: :purse

  before_save do
    self.activity_key = 'user.confirmed' if confirmed_at_changed?
    self.activity_key = 'user.completed' if state_changed? && completed?
    self.activity_key = 'user.invited' if invited_by_id && new_record?
    self.activity_key = 'user.partner' if parent_id && new_record?
    self.token = username.parameterize if username_changed? && username.present?
  end

  tracked on: {
    update: proc do |model|
      (model.state_changed? && model.completed?) ||
        model.confirmed_at_changed?
    end,
    create: proc { |model| model.invited_by_id || model.parent_id },
    delete: false
  }

  class << self
    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if (login = conditions.delete(:login)).present?
        where(conditions)
          .where('lower(phone) = :value OR lower(email) = :value',
                 value: login.downcase).first
      else
        where(conditions).first
      end
    end

    def total_users
      Rails.cache.fetch([name, 'counter'], expires_in: 5.minutes) do
        where(arel_table[:invitation_sent_at].eq(nil)
        .or(arel_table[:invitation_accepted_at].not_eq(nil))).count
      end
    end

    def owner
      admins.root
    end
  end

  def login
    @login || phone || email
  end

  def admin?
    role.eql?('admin')
  end

  def admin!
    update_attribute(:role, 'admin')
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def skip_cropping
    self.crop_x = self.crop_y = self.crop_w = self.crop_h = nil
  end

  def first_line
    children.nested_set
  end

  def sync_children_count!
    update(children_count: children.count)
  end

  def recreate_avatar_versions!
    avatar.recreate_versions!
    skip_cropping
  end

  protected

  def create_purse
    self.purse = Purse.create!(amount: 0) if purse.blank?
  end

  def generate_token
    return if token.present?
    loop do
      new_token = Digest::SHA1.hexdigest([Time.now.to_i,
                                          (1..10).map { rand.to_s }]
                                         .flatten.join('--'))[0, 6]
      self.token = new_token
      break if User.find_by(token: new_token).nil?
    end
  end

  def has_parent
    errors.add(:parent, :blank) if parent.blank?
  end
end
