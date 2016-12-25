# :nodoc:
module PlansConcern
  extend ActiveSupport::Concern

  included do
    # see more about enums #http://api.rubyonrails.org/v4.1.0/classes/ActiveRecord/Enum.html
    enum plan: { small: 0, payment: 1, credit: 2, investor: 3 }

    # purse purse_payment_activation_from_user detect auto pay small plan

    has_many :vouchers, class_name: 'Voucher::Base'
    has_one  :voucher, class_name: 'Voucher::Base'
    has_many :my_vouchers, class_name: 'Voucher::Base', foreign_key: :owner_id

    has_one  :activation_request
    has_many :activation_requests, foreign_key: :admin_id

    has_one  :voucher_request
    has_many :voucher_requests, foreign_key: :owner_id

    state_machine :state, initial: :pending do
      event :activate do
        transition pending: :activated
      end

      after_transition on: :activate do |user|
        user.class.unscoped do
          user.send(:actions_after_activate!)
        end
      end

      event :complete do
        transition activated: :completed
      end

      after_transition on: :complete do |user|
        user.class.unscoped do
          user.send(:actions_after_complete)
        end
      end
    end
  end

  def with_voucher?
    !vouchers.count.zero?
  end

  def base_activated?
    activated? || completed?
  end

  def activated_to_invite?
    (activation_request.present? && activation_request.completed?) ||
      (voucher_request.present? && voucher_request.is_valid?)
  end

  def activate_by_request!
    activate! if payment? || investor?
    send(:activation_parent_detect!) unless credit?
    send(:voucher_request!) if credit?
    activation_request.send(:callback_payments!)
  end

  def activate_with_voucher!
    update(plan: 'credit')
    send(:activation_parent_detect!)
  end

  def change_plan!(new_plan)
    return unless User.plans.keys.include?(new_plan)
    update(plan: new_plan)
  end

  def plan_partner_amount
    amounts = {
      credit:   Money.new(20 * 100),
      small:    Money.new(40 * 100),
      payment:  Money.new(400 * 100),
      investor: Money.new(400 * 100)
    }
    amounts[plan.to_sym]
  end

  def plan_system_amount(full)
    amounts = {
      credit:   Money.new(5 * 100),
      small:    Money.new(10 * 100),
      payment:  Money.new(100 * 100),
      investor: Money.new(100 * 100)
    }
    amount = amounts[plan.to_sym]
    if full
      amount += plan_partner_amount
      amount += plan_vouchers_amount.to_money
    end
    amount
  end

  def plan_vouchers_amount
    return 0 unless investor?
    Money.new(250 * 100)
  end

  def plan_system_fee
    plan_system_amount(false) / plan_system_amount(true)
  end

  def voucher_amount
    voucher.present? ? voucher.amount : 0
  end

  def vouchers_max(voucher_type)
    voucher_class = Voucher.class_type(voucher_type)
    return 0 unless voucher_class
    (purse.available_amount / voucher_class::AMOUNT.to_money).to_i
  end

  def vouchers_active(voucher_type)
    voucher_class = Voucher.class_type(voucher_type)
    my_vouchers.type(voucher_class).pending.count
  end

  def vouchers_activated(voucher_type)
    voucher_class = Voucher.class_type(voucher_type)
    my_vouchers.type(voucher_class).completed.count
  end

  def can_voucher_recommendation?
    credit_activation_limit > 0
  end

  def activate_current_payee(child)
    c = activation_count + 1
    if [2, 3].include?(c) &&
       (child.invited_by.nil? || child.parent.eql?(child.invited_by))
      'sponsor'
    elsif c.eql?(1) && voucher.present?
      'investor'
    else
      'parent'
    end
  end

  protected

  def credit_activation_limit!
    new_limit = 0
    new_limit = (payment? ? 5 : 1) if base_activated?
    pending_count = children.pending.joins(:vouchers).count
    new_limit -= pending_count
    update_attribute(:credit_activation_limit, new_limit)
  end

  def actions_after_activate!
    credit_activation_limit!
  end

  def activation_parent_detect!
    return unless (current_parent = parent).present?
    payee = current_parent.activate_current_payee(self)
    new_parent = if payee.eql?('sponsor')
                   current_parent.parent
                 elsif payee.eql?('investor')
                   voucher.owner || User.owner
                 end
    # TODO: add from to parent
    if new_parent.present?
      self.parent = new_parent
      self.invited_by = current_parent
      save(validate: false)
      new_parent.sync_children_count!
      current_parent.sync_children_count!
    end
    current_parent.increment(:activation_count)
    current_parent.save(validate: false)
  end

  def voucher_request!
    create_voucher_request
  end

  def small_activation_pay!
    plan_amount = plan_system_amount(true)
    purse = self.purse.reload
    available_amount = purse.available_amount

    if voucher.present?
      payment_target = voucher_request
      parent_purse = voucher.owner.purse
    else
      update(plan: 'small') unless small?
      if (activation_request = self.activation_request).blank?
        activation_request = create_activation_request
        activation_request.update_column(:state, 'active')
        activation_request.complete!
      elsif !activation_request.completed? &&
            available_amount >= plan_amount
        activation_request.system_deposit.cancel! unless activation_request.system_deposit.completed?
        activation_request.parent_deposit.cancel! if activation_request.parent_deposit && !activation_request.parent_deposit.completed?
        activation_request.update_column(:state, 'active')
        activation_request.complete!
      end
      parent_purse = parent.try(:purse)
      payment_target = activation_request
    end

    if available_amount >= plan_amount
      count = (available_amount / plan_amount).to_i
      pay_count = (purse.pay_activation_amount / plan_amount).to_i
      count = 20 - pay_count if count + pay_count > 20
      if count > 0
        payment_target.transaction do
          system_amount = plan_amount * count * plan_system_fee
          system_payment_params = {
            purse: purse,
            amount: - system_amount
          }
          system_payment = payment_target.purse_payment_system_activation_from_users.new(system_payment_params)
          system_payment.save!
          system_payment.complete!

          parent_amount = plan_amount * count * (1 - plan_system_fee)
          params = {
            source_purse: parent_purse,
            purse: purse,
            amount: - parent_amount
          }
          partner_payment = payment_target.purse_payment_activation_from_users.new(params)
          partner_payment.complete! if partner_payment.save!
        end
      end
    end
    if voucher.present?
      reload.send(:detect_all_credit_pay!)
    else
      reload.send(:detect_all_small_pay!)
    end
  end

  def detect_all_small_pay!
    activate! if purse.pay_activation_amount.eql?(plan_system_amount(true) * 20)
  end

  def detect_all_credit_pay!
    return unless purse.pay_activation_amount.eql?(plan_system_amount(true) * 20)
    voucher_request.complete!
  end
end
