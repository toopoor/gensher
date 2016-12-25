# == Schema Information
#
# Table name: purses
#
#  id           :integer          not null, primary key
#  amount_cents :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Purse < ActiveRecord::Base
  monetize :amount_cents, as: :amount
  ## Relationships
  has_one :user
  has_one :system_account
  has_many :purse_payment_activation_from_users, class_name: 'PursePayment::ActivationFromUser'
  has_many :purse_payments, class_name: 'PursePayment::Base' do
    def activations(type)
      where('type IN (?)', PursePayment::Base.activations_types[type.to_sym]).ordered
    end
  end

  after_save :activation_job!

  def pending_activation_payments
    purse_payments.pending.activations('all')
  end

  def system?
    system_account.present?
  end

  def pay_activation_amount
    #SUM activations from user to parent
    ((-self.purse_payment_activation_from_users.map(&:amount).sum/(1-user.plan_system_fee)) +
        user.voucher_amount).to_money
  end

  def current_activation_amount
    # amount by activation progress
    (pay_activation_amount + available_amount - user.voucher_amount).to_money
  end

  def blocked_amount
    purse_payments.blocked.pending.map(&:amount).sum.to_money
  end

  def available_amount
    amount + blocked_amount
  end

  def change!(amount)
    self.amount += amount
    save!
  end

  def activation_job!
    if self.available_amount > 0 && self.user && self.user.pending?
      Delayed::Job.enqueue({payload_object: SmallActivationJob.new(self.user.id), priority: 0, run_at: 2.minutes.from_now})
    end
  end
end
