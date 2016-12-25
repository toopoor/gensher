module Voucher
  class Segment < Base
    PERCENT = 50

    has_one :purse_payment_system_voucher_bonus, class_name: 'PursePayment::SystemVoucherBonus', as: :target #Оплата бонусного вознаграждения
    has_one :purse_payment_voucher_bonus,        class_name: 'PursePayment::VoucherBonus',       as: :target #Бонусное вознаграждение

    scope :limited, ->(c) { limit(c) }
    scope :active, ->(c) { pending.ordered.limited(c) }

    class << self
      def next_active
        c = self::FULL_COUNT
        (vouchers = active(c)).count.eql?(c) ? vouchers : nil
      end
    end

    protected

    def add_bonus!
      params = {
        amount: - ((self.class::AMOUNT * self.class::PERCENT) / 100).to_money,
        source_purse: owner.purse
      }
      bonus_payment = create_purse_payment_system_voucher_bonus(params)
      bonus_payment.complete! if bonus_payment.persisted?
    end
  end
end
