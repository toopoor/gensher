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
  class SystemDeposit < Deposit
    register_currency :usd

    has_one :activation_request, foreign_key: :system_deposit_id

    before_create :add_identifier
    before_create :generate_token

    def self.model_name
      ActiveModel::Name.new(self, nil, 'Payment')
    end

    private

    def action_after_complete
      activation_request.save
      super
      send(:activation_to_system!)
    end

    def add_identifier
      return if identifier.present?
      loop do
        new_identifier = SecureRandom.urlsafe_base64(10)
        self.identifier = new_identifier
        break if Deposit.find_by(identifier: new_identifier).nil?
      end
    end

    def activation_to_system!
      params = {
        purse: user.purse,
        amount: user.plan_system_amount(false)
      }
      payment = activation_request.build_purse_payment_system_activation_by_user(params)
      payment.save!
      payment.complete!
    end

    def callback_payments!
      return unless completed?
      back_to_parent!
      pay_vouchers!
    end

    def back_to_parent!
      params = {
        purse: user.purse,
        amount: user.plan_partner_amount
      }
      payment = activation_request.build_purse_payment_activation_by_user(params)
      payment.save!
      payment.complete!
    end

    def pay_vouchers!
      return unless user.investor?
      params = {
        purse: user.purse,
        amount: user.plan_vouchers_amount
      }
      payment = activation_request.build_purse_payment_activation_by_voucher(params)
      payment.save!
      payment.complete!
    end
  end
end
