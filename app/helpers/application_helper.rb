module ApplicationHelper

  def total_users
    User.total_users
  end

  def first_page_users
    logger.error('TODO Add Scope for active users on first page')
    @users ||= User.limit(6).decorate
  end

  def active_controller?(controller_name)
    'active' if params[:controller].eql?(controller_name)
  end

  def active_action?(action_name)
    'active' if params[:action].eql?(action_name)
  end

  def active_current_page?(path)
    'active' if current_page?(path)
  end

  def active_current_pages?(paths)
    paths.map { |path| active_current_page?(path) }.uniq.compact
  end

  def active_messages_page?
    params[:controller].eql?('messages') &&
      params[:action].eql?('index') && params[:message_type].nil?
  end

  def active_structure_pages?
    paths = [first_line_path,
             invited_path,
             structure_path,
             stats_path]
    active_current_pages?(paths)
  end

  def active_money_pages?
    paths = [payment_cash_deposits_path,
             payment_cash_withdrawals_path,
             purse_payment_activations_path,
             purse_payment_vouchers_path]
    active_current_pages?(paths)
  end

  def active_instruments_pages?
    paths = [instruments_first_line_path, new_user_invitation_path]
    active_current_pages?(paths)
  end

  def active_new_message_page?(type)
    active_current_page?(new_message_path(message_type: type))
  end

  def social_title(provider, sign)
    name = t(provider.to_s, scope: 'devise.omniauth.providers.names')
    return name if sign
    t('devise.shared.omniauth_links.sign_in_with', provider: name)
  end

  def social_class(provider)
    t(provider.to_s, scope: 'devise.omniauth.providers.btns')
  end

  def social_link_to(path, provider, sign)
    options = {
      title: social_title(provider, sign)
    }
    link_to('', path, options)
  end

  def social_li(path, provider, sign = true)
    content_tag(:li, class: social_class(provider)) do
      social_link_to(path, provider, sign)
    end
  end
end
