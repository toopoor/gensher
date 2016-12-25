module Voucher
  class Base < ActiveRecord::Base
    self.table_name = :vouchers

    belongs_to :owner, class_name: 'User' # Кто создал
    belongs_to :user                      # Кто активировал

    has_one :voucher_request, foreign_key: :voucher_id

    has_one :purse_payment_voucher_pay,         class_name: 'PursePayment::VoucherPay',        as: :target, dependent: :destroy #Создание ваучера
    has_one :purse_payment_system_voucher,      class_name: 'PursePayment::SystemVoucher',     as: :target #Оплата создания ваучера

    monetize :amount_cents, as: :amount, allow_nil: false, numericality: true

    validates_associated :owner

    before_validation :add_amount, on: :create
    after_create :add_payment

    scope :type,       -> (type){ where(type: type.to_s) }
    scope :pending,    -> { where(state: 'pending') }
    scope :activated,  -> { where(state: 'activated') }
    scope :completed,  -> { where(state: 'completed') }
    scope :ordered,    -> { order('created_at asc') }
    scope :active,     -> { pending.ordered }

    state_machine :state, initial: :pending do
      state :pending
      state :activated
      state :completed

      event :activate do
        transition pending: :activated
      end

      event :deactivate do
        transition activated: :pending
      end

      event :complete do
        transition activated: :completed
      end

      around_transition on: :activate do |voucher, transition, block|
        voucher.user = transition.args.first
        block.call
        voucher.send(:action_after_activate)
      end

      after_transition on: :deactivate do |voucher|
        voucher.send(:action_after_deactivate)
      end
    end

    class << self
      def next
        [
          ::Voucher::Credit.next_active.presence,
          ::Voucher::HalfSegment.next_active,
          ::Voucher::FiveSegment.next_active
        ].compact.sort_by { |x| x.first.try(:created_at) }.first
      end

      def small
        ::Voucher::Small.next_active.first
      end
    end

    def decorate
      VoucherDecorator.decorate(self)
    end

    protected

    def add_amount
      self.amount = self.class::AMOUNT.to_money
    end

    def add_payment
      params = {
        purse: owner.purse,
        amount: -self.class::AMOUNT.to_money
      }
      create_purse_payment_voucher_pay(params)
    end

    def action_after_activate
      purse_payment_voucher_pay.complete!
      user.activate_with_voucher!
    end

    def action_after_deactivate
      purse_payment_voucher_pay.back!
      user.update(plan: 'payment')
      update(user: nil)
    end

    # def complete!(payment) #TODO to state around
    #   params = {
    #       amount: -self.class::AMOUNT.to_money,
    #       source_purse: self.owner.purse,
    #       source_payment: payment
    #   }
    #   back_payment = self.create_purse_payment_system_voucher_back(params)
    #   back_payment.complete! if back_payment.persisted?
    # end
  end
end
