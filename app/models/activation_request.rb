class ActivationRequest < ActiveRecord::Base
  TAB_TYPES = %w(all pending managed active completed).freeze
  PUBLIC_ATTRS = [:created_at, :plan, :pay_system, :state,
                  :invoices, :comment].freeze
  PAY_SYSTEMS = %w(payeer perfect_money okpay advcash).freeze
  belongs_to :user
  belongs_to :admin, class_name: 'User'
  belongs_to :system_deposit, class_name: 'Payment::SystemDeposit',
                              autosave: true
  belongs_to :parent_deposit, class_name: 'Payment::ParentDeposit',
                              autosave: true

  has_one  :purse_payment_system_activation_by_user,
           class_name: 'PursePayment::SystemActivationByUser',
           as: :target # -> user activation to system
  has_many :purse_payment_system_activation_from_users,
           class_name: 'PursePayment::SystemActivationFromUser',
           as: :target # activation user -> system
  has_many :purse_payment_activation_by_systems,
           class_name: 'PursePayment::ActivationBySystem',
           as: :target # activation -> system

  has_one  :purse_payment_activation_by_user,
           class_name: 'PursePayment::ActivationByUser',
           as: :target # -> user activation to parent
  has_many :purse_payment_activation_from_users,
           class_name: 'PursePayment::ActivationFromUser',
           as: :target # activation user -> parent
  has_many :purse_payment_activation_by_parents,
           class_name: 'PursePayment::ActivationByParent',
           as: :target # activation -> parent

  has_one :purse_payment_activation_by_voucher,
          class_name: 'PursePayment::ActivationByVoucher',
          as: :target # -> investor activation -> vouchers

  before_create :detect_data!
  after_update :detect_state!

  scope :systemic,  -> { where(system: true) }
  scope :pending,   -> { where(state: 'pending') }
  scope :managed,   -> { where(state: 'managed') }
  scope :active,    -> { where(state: 'active') }
  scope :completed, -> { where(state: 'completed') }
  scope :ordered,   -> { order(created_at: :desc) }
  scope :pending_or_active, -> { where(state: %w(pending active)) }

  mount_uploader :system_invoice_file, SystemInvoiceUploader
  mount_uploader :parent_invoice_file, ParentInvoiceUploader

  state_machine :state, initial: :pending do
    event :manage do
      transition pending: :managed
    end

    event :activate do
      transition managed: :active
    end

    event :complete do
      transition active: :completed
    end

    after_transition on: :complete do |activation_request, transition|
      activation_request.class.unscoped do
        activation_request.user.activate_by_request!
      end
    end
  end

  def self.pending_count
    pending_or_active.count
  end

  def parent
    user.parent
  end

  def can_manage?(user)
    user.admin? || admin.eql?(user)
  end

  def manage_by!(user)
    build_parent_deposit(parent_deposit_params) if can_manage_parent_deposite?(user)
    build_system_deposit(system_deposit_params) if can_manage_system_deposite?(user)
    save
  end

  def complete_by!(user)
    parent_deposit.complete! if can_manage_parent_deposite?(user)
    system_deposit.complete! if can_manage_system_deposite?(user)
  end

  def full_invoices?
    system_invoice_file.present? && (system? || parent_invoice_file.present?)
  end

  def payments_completed?
    (parent_deposit.blank? || parent_deposit.completed?) &&
      (system_deposit.blank? || system_deposit.completed?)
  end

  def parent_complete?
    parent.present? && (parent.completed? || parent.admin?)
  end

  private

  def detect_data!
    self.system = parent.blank? || parent.admin? || !parent.completed?
    self.admin =  parent_complete? ? parent : User.admins.first
  end

  def can_manage_parent_deposite?(user)
    !system? && admin.eql?(user)
  end

  def can_manage_system_deposite?(user)
    user.admin?
  end

  def parent_deposit_params
    {
      amount: user.plan_partner_amount,
      user: user
    }
  end

  def system_deposit_params
    {
      amount: user.plan_system_amount(system),
      user: user
    }
  end

  def detect_state!
    case state
    when 'pending'
      manage! if system_deposit.present? && (system? || parent_deposit.present?)
    when 'managed'
      activate! if full_invoices?
    when 'active'
      complete! if payments_completed?
    end
  end

  def callback_payments!
    return unless system_deposit.present? && system?
    system_deposit.send(:callback_payments!)
  end
end
