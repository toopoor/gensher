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
  class SystemActivationByUser < Deposit
    has_one :purse_payment_system_activation_from_user,
            class_name: 'PursePayment::SystemActivationFromUser',
            foreign_key: :source_payment_id # Куда

    private

    def add_details
      self.name ||=        I18n.t('name',
                                  scope: self.class.translate_scope)
      self.description ||= I18n.t('description',
                                  scope: self.class.translate_scope, id: id)
      save
    end

    def action_after_complete
      if user.payment? || user.investor?
        # auto payment activation by system
        params = {
          purse: purse,
          amount: - amount,
          source_payment: self
        }
        payment = target.purse_payment_system_activation_from_users.create(params)
        payment.complete! if payment.save!
      end
      super
    end
  end
end
