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
  class ActivationByVoucher < Deposit
    private

    def add_details
      self.name ||=        I18n.t('name',
                                  scope: self.class.translate_scope)
      self.description ||= I18n.t('description',
                                  scope: self.class.translate_scope,
                                  id: id)
      save
    end

    def action_after_complete
      super
      Array.new(10).map { Voucher::Small.create(owner: purse.user) }
    end
  end
end
