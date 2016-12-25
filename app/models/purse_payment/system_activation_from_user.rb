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
  class SystemActivationFromUser < Withdrawal
    belongs_to :source_payment,
               class_name: 'PursePayment::SystemActivationByUser' # Откуда
    has_one :purse_payment_activation_by_system,
            class_name: 'PursePayment::ActivationBySystem',
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

    private

    def add_details
      self.name ||= I18n.t('name', scope: self.class.translate_scope)
      self.description ||= I18n.t('description',
                                  scope: self.class.translate_scope, id: id)
      save
    end

    def action_after_complete
      params = {
        source_purse: purse,
        amount: - amount,
        source_payment: self
      }
      payment = target.purse_payment_activation_by_systems.create(params)
      payment.complete! if payment.save!
      super
    end
  end
end
