class VoucherRequestDecorator < Draper::Decorator
  delegate_all

  def created_at
    I18n.l(object.created_at, format: :short)
  end

  def activate_link
    return unless can_activate?(h.current_user)
    h.link_to(h.t('voucher_requests.activate_link'),
              h.activate_voucher_request_path(object),
              remote: true, class: 'btn btn-sm btn-info')
  end

  def cancel_link
    h.link_to(h.t('voucher_requests.cancel_link'), h.cancel_voucher_request_path(object), remote: true, class: 'btn btn-sm btn-default') if object.pending?
  end

  def reject_link
    h.link_to(h.t('voucher_requests.reject_link'), h.reject_voucher_request_path(object), remote: true, class: 'btn btn-sm btn-warning') if activated? && progress_bad?
  end

  def css
    colors = {
      pending:   'danger',
      activated: 'info',
      completed: 'success',
      canceled:  'warning',
      rejected:  'warning'
    }
    css = [h.dom_class(object)]
    css.push colors[object.state.to_sym]
    css.join(' ')
  end

  def link_to_profile
    user.link_to_profile
  end

  def state
    h.t(object.state, scope: 'voucher_requests.states')
  end

  def phone
    user.phone
  end

  def skype
    user.skype
  end

  def sponsor
    if object.owner.present?
      object.owner.decorate.link_to_profile
    else
      '-'
    end
  end

  def progress_time_left
    duration = (object.activated_at+2.weeks-Time.current).to_i
    days = duration / 86400
    hours = (duration / (3600)) % 24
    minutes = (duration / 60) % 60
    seconds = duration % 60
    "#{days} #{Russian.p(days, 'день', 'дня', 'дней', 'дня')} #{ hours }:#{ minutes }:#{ seconds }" if days >= 0
  end

  def activate_period
    text = ''
    if progress_days > 0
      text << h.content_tag(:div, [progress_days, Russian.p(progress_days, 'день', 'дня', 'дней', 'дня')].join(' '))
      text << h.content_tag(:label, class: 'label label-danger'){
        [h.content_tag(:i, '', class: 'fa fa-warning'), h.t('voucher_requests.states.expired')].join(' ').html_safe} if progress_bad?
    end
    text.html_safe
  end

  def progress_days
    progress_duration / 86400
  end

  def progress_duration
    (object.activated_at ? (Time.current-object.activated_at) : 0).to_i
  end

  def progress_expired?
    progress_duration>2.weeks
  end

  def progress_bad?
    !object.in_progress? && progress_expired?
  end

  protected
  def user
    object.user.decorate
  end
end
