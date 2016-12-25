class ActivationRequestDecorator < Draper::Decorator
  delegate_all

  def created_at
    I18n.l(object.created_at, format: :short)
  end

  def plan
    h.safe_join([object.user.decorate.plan,
                 object.user.plan_system_amount(true).format],
                '<br/>'.html_safe)
  end

  def pay_system
    h.image_tag("pays/#{object.pay_system}.jpg",
                class: 'activation_request__pay_system')
  end

  def manage_link
    h.link_to(h.t('activation_requests.manage_link'), '', data: { toggle: 'modal', target: '#activation-request-comment-modal', url: h.manage_activation_request_path(object) }, class: 'btn btn-sm btn-danger') if object.pending?
  end

  def change_link
    h.link_to(h.t('activation_requests.change'), '', data: { toggle: 'modal', target: '#activation-request-change-plan-modal', url: h.change_plan_activation_request_path(object), plan: object.user.plan }, class: 'btn btn-sm btn-primary margin-top-10') if object.pending?
  end

  def cancel_link
    h.link_to(h.t('activation_requests.remove'), object, remote: true, method: :delete, data: {confirm: h.t('static.are_you_sure')}, class: 'btn btn-sm btn-warning margin-top-10') if object.pending?
  end

  def need_parent_invoice?
    !object.system? && object.read_attribute(:parent_invoice_file).blank?
  end

  def need_system_invoice?
    object.read_attribute(:system_invoice_file).blank?
  end

  def invoice_link(type)
    link_name = object.system? ? 'full_system' : type
    h.link_to(h.t(link_name, scope: 'activation_requests.invoice_links'), h.invoice_activation_request_path(id: object.id, type: type), target: '_blank') if object.read_attribute("#{type}_invoice_file".to_sym).present?
  end

  def invoices
    [invoice_link('parent'), invoice_link('system')].compact.join('<br/>').html_safe
  end

  def complete_link
    h.link_to(h.t('activation_requests.complete_link'), h.complete_activation_request_path(object), remote: true, class: 'btn btn-sm btn-info') if object.active?
  end

  def show_link
    object.user.decorate.show_link
  end

  def link_to_profile
    user.link_to_profile
  end

  def state
    h.t(object.state, scope: 'activation_requests.states')
  end

  def css
    colors = {
      pending:   'danger',
      managed:   'info',
      active:    'warning',
      completed: 'success'
    }
    css = [h.dom_class(object), h.dom_id(object)]
    css.push colors[object.state.to_sym]
    css.join(' ')
  end

  def phone
    user.phone
  end

  def skype
    user.skype
  end

  protected

  def user
    object.user.decorate
  end
end
