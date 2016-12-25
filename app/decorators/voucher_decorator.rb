class VoucherDecorator < Draper::Decorator
  delegate_all

  def created_at
    I18n.l(object.created_at, format: :short)
  end

  def css
    colors = {
        pending:   'danger',
        activated: 'info',
        completed: 'success',
        canceled:  'warning'
    }
    css = [h.dom_class(object)]
    css.push colors[object.state.to_sym]
    css.join(' ')
  end

  def link_to_owner
    owner.link_to_profile
  end

  def state
    h.t(object.state, scope: 'vouchers.states')
  end

  def owner_phone
    owner.phone
  end

  def owner_skype
    owner.skype
  end

  def link_to_profile
    user ? user.link_to_profile : '-'
  end

  def link_to_destroy
    h.link_to(h.icon('ban'), h.voucher_path(object), remote: true, method: :delete, title: I18n.t('static.destroy'), data: {confirm: I18n.t('static.are_you_sure')}, class: 'btn btn-xs btn-danger') if object.pending?
  end

  def show_link
    object.type
  end

  protected
  def user
    object.user.try(:decorate)
  end

  def owner
    object.owner.decorate
  end
end