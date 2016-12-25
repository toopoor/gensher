module Payment
  class Base < ActiveRecord::Base
    self.table_name = :payments
    PUBLIC_ATTRS = [:created_at, :amount, :identifier, :type, :state,
                    :user_balance, :payer_id, :comment, :invoice_file].freeze
    belongs_to :user

    attr_accessor :is_system, :terms_of_service
    monetize :amount_cents, as: :amount

    validates :user_id,          presence:     { unless: ->(payment) { payment.is_system } }
    validates :token,            uniqueness:   true, allow_nil: true
    validates :identifier,       uniqueness:   true, allow_nil: true
    validates :amount,           numericality: { greater_than_or_equal_to: 0 }
    validates :terms_of_service, acceptance:   true

    scope :pending,   -> { where(state: 'pending') }
    scope :canceled,  -> { where(state: 'canceled') }
    scope :completed, -> { where(state: 'completed') }
    scope :ordered,   -> { order('created_at desc') }

    attr_reader :terms_of_service

    state_machine :state, initial: :pending do
      state :pending
      state :canceled
      state :completed
      state :failed

      event :cancel do
        transition pending: :canceled, canceled: :canceled
      end

      event :complete do
        transition pending: :completed, canceled: :completed
      end

      event :failed do
        transition pending: :failed
      end

      after_transition on: :complete do |payment, transition|
        payment.send(:action_after_complete)
      end
    end

    class << self
      def translate_scope
        :"payments.#{model_name.i18n_key}"
      end

      def pending_count
        Payment::CashDeposit.pending.count + Payment::CashWithdrawal.pending.count
      end
    end

    def to_manage?(user)
      false
    end

    def to_complete?(user)
      !completed? && !type.match(/System/) && user.admin?
    end

    def payment_name
      self.class.to_s.underscore.tr('/', '_')
    end

    def is_system
      @is_system || respond_to?(:purse_payment_system_withdrawal) && self.purse_payment_system_withdrawal.present?
    end

    def decorate
      PaymentDecorator.decorate(self)
    end
  end
end
