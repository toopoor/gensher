# == Schema Information
#
# Table name: payments
#
#  id           :integer          not null, primary key
#  type         :string(255)
#  user_id      :integer
#  amount_cents :integer          default(0), not null
#  currency     :string(255)      default("USD")
#  token        :string(255)
#  identifier   :string(255)
#  payer_id     :string(255)
#  state        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#
module Payment
  class Withdrawal < Base
    PAY_SYSTEMS = %w(payeer perfect_money okpay advcash cash).freeze
    FEE = 0
    has_one :purse_payment_purse_withdrawal,
            class_name: 'PursePayment::PurseWithdrawal',
            as: :target
    # has_one :purse_payment_system_withdrawal_fee, class_name: 'PursePayment::SystemWithdrawalFee', as: :target
    register_currency :usd

    validate :amount_in_purse?, on: :create

    def payment_system_name
      payment_base_name.sub('Withdrawal', '')
    end

    def payment_base_name
      type.split(/::/).last
    end

    def to_param
      token
    end

    def payment_fee_amount
      nil
    end

    def gsd_amount
      amount.exchange_to('GSD')
    end

    def amount_with_fee
      gsd_amount * (1 + FEE)
    end

    protected

    def add_withdrawal_fee
      return unless payment_fee_amount.present? && purse_payment_system_withdrawal_fee.blank?
      payment = build_purse_payment_system_withdrawal_fee(amount: payment_fee_amount)
      payment.complete! if payment.save!
    end

    def action_after_complete
      purse_payment_purse_withdrawal.complete!
    end

    def generate_token
      return if token.present?
      loop do
        new_token = SecureRandom.random_number(10**9).to_s
        self.token = new_token
        break if Payment::Base.find_by(token: new_token).nil?
      end
    end

    def add_identifier
      return if identifier.present?
      loop do
        new_identifier = SecureRandom.urlsafe_base64(10)
        self.identifier = new_identifier
        break if Withdrawal.find_by(identifier: new_identifier).nil?
      end
    end

    def amount_in_purse?
      errors.add(:amount, :no_amount_in_user_purse) if user && amount_with_fee > user.purse.available_amount
    end
  end
end
