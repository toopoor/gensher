class VoucherRequest < ActiveRecord::Base
  TAB_TYPES = %w(all pending active completed canceled).freeze
  PUBLIC_ATTRS = [:created_at, :state, :sponsor].freeze
  belongs_to :owner, class_name: 'User'
  belongs_to :user
  belongs_to :voucher, class_name: 'Voucher::Base'

  has_many :purse_payment_system_activation_from_users, class_name: 'PursePayment::SystemActivationFromUser', as: :target #активация от пользователя в систему
  has_many :purse_payment_activation_by_systems, class_name: 'PursePayment::ActivationBySystem', as: :target #активация в систему

  has_many :purse_payment_activation_from_users, class_name: 'PursePayment::ActivationFromUser', as: :target #активация от пользователя
  has_many :purse_payment_activation_by_investors, class_name: 'PursePayment::ActivationByInvestor', as: :target #активация к инвестору


  scope :pending,   -> {where(state: 'pending')}
  scope :active,    -> {where(state: 'activated')}
  scope :completed, -> {where(state: 'completed')}
  scope :canceled,  -> {where(state: 'canceled')}
  scope :not_rejected, -> { where.not(state: 'rejected') }
  scope :ordered,   -> {order(created_at: :desc)}


  state_machine :state, initial: :pending do
    state :pending
    state :activated
    state :completed
    state :rejected
    state :canceled

    event :activate do
      transition pending: :activated
    end

    event :complete do
      transition activated: :completed
    end

    event :reject do
      transition activated: :rejected
    end

    event :cancel do
      transition pending: :canceled
    end

    around_transition on: :activate do |voucher_request, transition, block|
      voucher = Voucher::Base.small
      voucher_request.activated_at = Time.current
      voucher_request.voucher = voucher
      voucher_request.owner = voucher.owner
      block.call
      voucher_request.voucher.activate!(voucher_request.user)
    end

    after_transition on: :reject do |voucher_request, transition|
      voucher_request.voucher.deactivate!
    end

    around_transition on: :complete do |voucher_request, transition, block|
      voucher_request.completed_at = Time.current
      block.call
      voucher_request.voucher.complete!
    end
  end

  def is_valid?
    activated? || completed?
  end

  def can_activate?(u)
    can_manage?(u) && pending? && user.pending? && !Voucher::Base.pending.count.zero?
  end

  def can_manage?(user)
    user.admin?
  end

  def in_progress?
    !purse_payment_activation_by_investors.count.zero?
  end
end
