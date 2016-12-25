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
  class CashDeposit < Deposit
    register_currency :usd

    validates :amount, numericality: { greater_than_or_equal_to: 25 }

    before_create :add_identifier
    before_create :generate_token
    after_update :detect_activate!

    scope :pending_manage, -> { where(state: %w(pending managed active)) }

    mount_uploader :invoice_file, InvoiceUploader

    state_machine :state, initial: :pending do
      event :manage do
        transition pending: :managed
      end

      event :activate do
        transition managed: :active
      end

      event :complete do
        transition managed: :completed, active: :completed
      end
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, 'Payment')
    end

    def to_manage?(user)
      pending? && user.admin?
    end

    def to_complete?(user)
      (managed? || active?) && user.admin?
    end

    private

    def action_after_complete
      amount = self.amount.exchange_to('GSD')
      deposit = build_purse_payment_purse_deposit(purse: user.purse, amount: amount)
      deposit.complete! if deposit.save!
      send(:add_deposit_fee)
    end

    def add_identifier
      return if identifier.present?
      loop do
        new_identifier = SecureRandom.urlsafe_base64(10)
        self.identifier = new_identifier
        break if Deposit.find_by(identifier: new_identifier).nil?
      end
    end

    def detect_activate!
      activate! if managed? && invoice_file.present?
    end
  end
end
