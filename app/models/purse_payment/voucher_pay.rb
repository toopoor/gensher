class PursePayment::VoucherPay < PursePayment::Withdrawal

  has_one :purse_payment_system_voucher, class_name: 'PursePayment::SystemVoucher', foreign_key: :source_payment_id

  class << self
    def blocked?
      true
    end

    def for_user?
      true
    end

    def system?
      false
    end
  end

  def back!
    self.purse_payment_system_voucher.back!
    self.update(state: 'pending')
    self.purse.change!(- self.amount)
  end

  private
  def add_details
    self.name =        I18n.t('name',
                              scope: self.class.translate_scope,
                              voucher: self.target.class.model_name.human) if self.name.blank?
    self.description = I18n.t('description',
                              scope: self.class.translate_scope,
                              voucher: self.target.class.model_name.human,
                              id: self.id) if self.description.blank?
    self.save
  end


  def action_after_complete
    params = {
        source_purse: self.purse,
        purse: self.source_purse,
        amount: - self.amount,
        source_payment: self
    }
    payment = self.target.create_purse_payment_system_voucher(params)
    payment.complete! if payment.save!
    super
  end
end
