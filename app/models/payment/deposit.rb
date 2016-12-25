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
  class Deposit < Base
    PAY_SYSTEMS = %w(payeer perfect_money okpay advcash).freeze
    has_one :purse_payment_purse_deposit,
            class_name: 'PursePayment::PurseDeposit',
            as: :target
    # has_one :purse_payment_system_deposit_fee, class_name: 'PursePayment::SystemDepositFee', as: :target
    register_currency :usd

    def payment_system_name
      payment_base_name.sub('Deposit', '')
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

    private

    def add_deposit_fee
      return unless payment_fee_amount.present? && purse_payment_system_deposit_fee.blank?
      payment = build_purse_payment_system_deposit_fee(amount: payment_fee_amount)
      payment.complete! if payment.save!
    end

    def action_after_complete
      # TODO: add after complete
      # amount = self.amount.exchange_to('GSD')
      # deposit = self.build_purse_payment_purse_deposit(purse: self.user.purse, amount: amount)
      # deposit.complete! if deposit.save!
      # self.send(:add_deposit_fee)
    end

    def generate_token
      return if token.present?
      loop do
        new_token = SecureRandom.random_number(10**9).to_s
        self.token = new_token
        break if Payment::Base.find_by(token: new_token).nil?
      end
    end
  end
end
