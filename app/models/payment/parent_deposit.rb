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
  class ParentDeposit < Deposit
    register_currency :usd

    has_one :activation_request, foreign_key: :parent_deposit_id

    before_create :add_identifier
    before_create :generate_token

    def self.model_name
      ActiveModel::Name.new(self, nil, 'Payment')
    end

    private
    def action_after_complete
      self.activation_request.save
      super
    end

    def add_identifier
      begin
        identifier = SecureRandom.urlsafe_base64(10)
      end while Deposit.find_by(identifier: identifier).present?
      self.identifier = identifier if self.identifier.blank?
    end
  end
end
