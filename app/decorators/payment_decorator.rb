class PaymentDecorator < Draper::Decorator
  delegate_all

  def created_at
    I18n.l(object.created_at, format: :short)
  end

  def amount
    if h.current_user.admin?
      h.best_in_place(object, :amount, display_with: :number_to_currency, helper_options: { locale: :en })
    else
      object.amount.format
    end
  end

  def type
    object.payment_base_name
  end
  alias_method :show_link, :type

  def state
    I18n.t(object.state, scope: 'states')
  end

  def state_notify_css
    colors = {
      pending:   'text-danger',
      managed:   'text-info',
      active:    'text-warning',
      completed: 'text-success',
      canceled:  ''
    }
    colors[object.state.to_sym]
  end

  def state_notify
    I18n.t(object.state, scope: object.type.to_s.underscore+'.states.')
  end

  def identifier
    h.current_user.admin? ? object.identifier : h.link_to(object.identifier, h.payment_cash_deposit_path(object)) #TODO add dynamic path
  end

  def is_system?
    object.payment_system_name.eql?('System')
  end

  def payer_id
    h.image_tag("pays/#{object.payer_id}.jpg", class: 'payment__payer_id') if object.payer_id.present?
  end

  def css
    colors = {
      pending: 'danger',
      completed: 'success',
      canceled: 'warning'
    }
    css = [h.dom_id(object)]
    css.push colors[object.state.to_sym]
    css.join(' ')
  end

  def invoice_file
    if object.read_attribute(:invoice_file).present?
      if h.current_user.try(:admin?)
        h.link_to(h.t('payment.invoice_file'), h.invoice_payment_path(object), target: '_blank')
      else
        h.t('payment.invoice_file_added')
      end
    end

  end

  def user_balance
    object.user.decorate.balance
  end

  def manage_link
    return unless object.to_manage?(h.current_user)
    h.link_to(h.icon('comment-o'), '', data: { toggle: 'modal', target: '#payment-comment-modal', url: h.manage_payment_path(object) }, class: 'btn btn-sm btn-success')
  end

  def cancel_link
    return if is_system? || !object.pending?
    url = h.current_user.admin? ? h.cancel_payment_path(object) : h.polymorphic_path(object, action: :cancel)
    h.link_to(h.icon('ban'), url, remote: true, title: I18n.t('static.cancel'), data: { confirm: I18n.t('static.are_you_sure') }, class: 'btn btn-xs btn-danger')
  end

  def complete_link
    return if is_system? || !object.to_complete?(h.current_user)
    h.link_to(h.icon('check'), h.complete_payment_path(object), remote: true, title: I18n.t('static.complete'), class: 'btn btn-xs btn-info')
  end
end
