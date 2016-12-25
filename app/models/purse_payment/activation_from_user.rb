# == Schema Information
#
# Table name: purse_payments
#
#  id                :integer          not null, primary key
#  type              :string(255)
#  source_purse_id   :integer
#  purse_id          :integer
#  source_payment_id :integer
#  target_id         :integer
#  target_type       :string(255)
#  name              :string(255)
#  description       :text
#  amount_cents      :integer          default(0), not null
#  state             :string(255)
#  params            :text
#  created_at        :datetime
#  updated_at        :datetime
#
module PursePayment
  class ActivationFromUser < Withdrawal
    belongs_to :source_payment,
               class_name: 'PursePayment::ActivationByUser' # Откуда
    has_one :purse_payment_activation_by_parent,
            class_name: 'PursePayment::ActivationByParent',
            foreign_key: :source_payment_id # Куда

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

    def translate_trefix
      by_voucher? ? 'voucher.' : ''
    end

    def by_voucher?
      target.is_a?(VoucherRequest)
    end

    private

    def add_details
      self.name ||= I18n.t("#{translate_trefix}name", scope: self.class.translate_scope)
      self.description ||= I18n.t("#{translate_trefix}description",
                                  scope: self.class.translate_scope,
                                  parent: (source_purse.user.parent.decorate.full_name rescue ''),
                                  id: id)
      save
    end

    def action_after_complete
      params = {
        source_purse: purse,
        purse: source_purse,
        amount: - amount,
        source_payment: self
      }
      payment = if by_voucher?
                  target.purse_payment_activation_by_investors.new(params)
                else
                  target.purse_payment_activation_by_parents.new(params)
                end
      payment.complete! if payment.save!
      super
    end
  end
end
