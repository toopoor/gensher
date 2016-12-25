module PursePayment
  class SystemVoucher < Deposit
    belongs_to :source_payment, class_name: 'PursePayment::VoucherPay' # Откуда

    class << self
      def system?
        true
      end

      def in_filter?
        true
      end
    end

    def back!
      purse.change!(- amount)
      destroy
    end

    private

    def add_details
      self.name ||=        I18n.t('name',
                                  scope: self.class.translate_scope,
                                  voucher: target.class.model_name.human)
      self.description ||= I18n.t('description',
                                  scope: self.class.translate_scope,
                                  voucher: target.class.model_name.human,
                                  user: target.owner.decorate.full_name,
                                  id: id)
      save
    end
  end
end
