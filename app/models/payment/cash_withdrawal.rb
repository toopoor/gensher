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
  class CashWithdrawal < Withdrawal
    register_currency :usd

    validates :amount, numericality: { greater_than_or_equal_to: 25 }

    before_create :add_identifier
    before_create :generate_token

    scope :pending_manage, -> { where(state: %w(pending managed active)) }

    state_machine :state, initial: :pending do
      event :complete do
        transition pending: :completed
      end
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, 'Payment')
    end

    def to_manage?(user)
      false # pending? && user.admin?
    end

    def to_complete?(user)
      pending? && !completed? && user.admin?
    end

    private

    def action_after_complete
      amount = - self.amount.exchange_to('GSD')
      withdrawal = build_purse_payment_purse_withdrawal(purse: user.purse, amount: amount)
      withdrawal.complete! if withdrawal.save!
      send(:add_withdrawal_fee)
    end
  end
end
