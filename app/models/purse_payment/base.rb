
module PursePayment
  class Base < ActiveRecord::Base
    self.table_name = :purse_payments
    SUBCLASSES = %w(
      PursePayment::PurseDeposit PursePayment::SystemDepositFee
      PursePayment::ActivationByParent PursePayment::ActivationBySystem
      PursePayment::ActivationByUser PursePayment::ActivationFromUser
      PursePayment::SystemActivationByUser PursePayment::SystemActivationFromUser
      PursePayment::ActivationByVoucher
      PursePayment::VoucherPay PursePayment::SystemVoucher
    ).freeze

    paginates_per 20

    belongs_to :source_purse, class_name: 'Purse'
    belongs_to :purse
    belongs_to :source_payment
    belongs_to :target, polymorphic: true

    monetize :amount_cents, as: :amount, allow_nil: false, numericality: true

    delegate :user, to: :purse

    serialize :params

    before_create :add_purse_to_system_payment, if: :system_purse_blank?

    after_create :add_details # before dont have id

    scope :blocked,    -> { where(type: self.blocked_types) }
    scope :pending,    -> { where(state: 'pending'  ) }
    scope :canceled,   -> { where(state: 'canceled' ) }
    scope :completed,  -> { where(state: 'completed') }
    scope :systemic,   -> { where(type: self.system_types) }
    scope :ordered,    -> { order(id: :desc) }
    scope :deposit,    -> { where('amount_cents > 0') }
    scope :withdrawal, -> { where('amount_cents < 0') }

    state_machine :state, initial: :pending do
      state :pending
      state :canceled
      state :completed
      state :failed

      event :cancel do
        transition pending: :canceled, canceled: :canceled
      end

      event :complete do
        transition pending: :completed
      end

      event :failed do
        transition pending: :failed
      end

      after_transition on: :complete do |payment, transition|
        payment.send(:action_after_complete)
      end
    end

    class << self
      def to_name
        I18n.t('type', scope: translate_scope)
      end

      def translate_scope
        :"purse_payments.#{model_name.i18n_key}"
      end

      def system?
        false
      end

      def blocked?
        false
      end

      def blocked_complete? # TODO: remove after unblock all payments
        false
      end

      def in_filter?
        false
      end

      def system_amount
        SystemAccount.gensherman.purse.amount
      end

      def all_types
        self::SUBCLASSES.sort
      end

      def system_types
        all_types.select { |type| type.constantize.system? }
      end

      def filter_types
        all_types.select { |type| type.constantize.in_filter? }
      end

      def types
        all_types.select { |type| !type.constantize.system? }
      end

      def user_types
        types.select { |type| type.constantize.for_user? }
      end

      def blocked_types
        types.select { |type| type.constantize.blocked? }
      end

      def type_to_subclass(type)
        all_types.select { |t| t.match('::' + type.classify) }.first
      end

      def tab_types_by(user)
        user.admin? ? PursePayment::TAB_TYPES : PursePayment::TAB_TYPES - %w(systemic)
      end

      def activations_types
        {
          all: %w(PursePayment::ActivationByParent),
          first: %w(PursePayment::ActivationByParent)
        }
      end

      def public_attrs_by(user)
        if user.admin?
          [:created_at, :purse, :source_purse, :source_payment, :target, :name, :amount, :state]
        else
          [:created_at, :name, :amount, :state]
        end
      end

      def show_attrs
        [:payment_name, :purse, :source_purse, :source_payment, :target, :name,
         :amount, :state, :created_at, :description, :params]
      end

      def activations_attrs
        [:name, :description, :created_at, :source_purse, :amount]
      end
    end

    def blocked_complete? # TODO: remove after unblock all payments
      self.class.blocked_complete? # false
    end

    def payment_name
      self.class.to_s.underscore.tr('/', '_')
    end

    def system_purse_blank?
      purse.blank? && self.class.system?
    end

    def source_payment_id
      params.present? && params[:source_payment_id]
    end

    def source_payment
      super || source_payment_id ? PursePayment::Base.find_by(id: source_payment_id.to_i) : nil
    end

    def decorate
      PursePaymentDecorator.decorate(self)
    end

    protected

    def add_purse_to_system_payment
      self.purse = SystemAccount.gensherman.purse
    end

    def action_after_complete
      purse.change!(amount)
    end

    def add_details
      nil
    end
  end
end
