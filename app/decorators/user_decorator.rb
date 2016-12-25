class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    str = "#{object.first_name} #{object.middle_name} #{object.last_name}"
    str.blank? ? object.email.split('@').first : str
  end

  def short_name
    str = "#{object.first_name} #{object.last_name}"
    str.blank? ? object.email.split('@').first : str
  end

  def link_to_profile
    h.link_to(short_name, h.profile_user_path(object), class: 'profile')
  end
  alias_method :show_link, :link_to_profile

  def icon
    h.image_tag(object.avatar.source.icon.url, class: 'img-icon')
  end

  def thumb
    h.image_tag(object.avatar.source.thumb.url, class: 'img-thumbnail')
  end

  def phone
    h.number_to_phone(object.phone)
  end

  def skype
    return '' if object.skype.blank?
    h.link_to(h.icon('skype') + " #{object.skype}", "skype:#{object.skype}?call")
  end

  def skype_chat
    return '' if object.skype.blank?
    h.link_to(h.icon('skype'), "skype:#{object.skype}?chat")
  end


  def social_links
    object.authentications.order(:provider).collect do |auth|
      h.link_to(h.icon(auth.provider, '', class: 'fa-2x active'), auth.url, title: auth.provider)
    end
  end

  def landing_social_li(auth)
    h.content_tag(:li) do
      h.link_to(h.safe_join([h.icon(h.t(auth.provider.to_s, scope: 'devise.omniauth.providers.icons')),
                             h.t(auth.provider.to_s, scope: 'devise.omniauth.providers.titles')]), auth.url)
    end
  end

  def landing_social_links
    h.content_tag(:ul) do
      object.authentications.order(:provider).map do |auth|
        h.concat landing_social_li(auth)
      end
    end
  end

  def social_links_inspinia
    h.content_tag(:div, class: 'social-icons full-opacity white-color') do
      h.content_tag(:ul) do
        object.authentications.order(:provider).map do |auth|
          h.concat h.social_li(auth.url, auth.provider)
        end
        h.concat h.social_li("skype:#{object.skype}?chat", 'skype')
      end
    end
  end

  def social_icon(provider)
    if provider == "vkontakte"
      icon_name = "vk"
    else
      icon_name = "#{provider}"
    end
    h.icon(icon_name, '')
  end

  def facebook_url
    return unless (auth = object.authentications.provider('facebook').first).present?
    auth.url
  end

  def position
    'интернет-предприниматель'
  end

  def token
    object.token.parameterize
  end

  def tree_show
    h.content_tag(:div, icon, class: 'col-xs-2')+
    h.content_tag(:div,  class: 'col-xs-4'){
      link_to_profile + '<br>'.html_safe +  h.link_to(h.icon('envelope'), 'mailto:'+object.email) + ' ' + skype + balance_label('pull-right balance')
    }.html_safe
  end

  def tree_controls
    ''
    # TODO: add recomendation by voucher request
  end

  def balance
    object.purse.available_amount.format
  end

  def balance_label(css = '')
    h.current_user.admin? || h.current_user.eql?(object) ? h.content_tag(:label, balance, class: "label label-danger #{css}") : ''
  end

  def create_voucher_link
    h.link_to(h.t('vouchers.create'), h.purse_payment_vouchers_path, class: 'btn btn-default') if object.base_activated?
  end

  def status
    st = object.state
    return st unless object.pending?
    return 'small_activated' if object.activated_to_invite?
    return 'voucher' if object.with_voucher?
    st
  end

  def plan_state
    h.t(status, scope: 'user.states')
  end

  def created_at
    I18n.l(object.created_at, format: :short)
  end

  def updated_at
    I18n.l(object.updated_at, format: :short)
  end

  def change_credit_plan
    change_plan_btn('credit')
  end

  def change_small_plan
    change_plan_btn('small')
  end

  def change_payment_plan
    change_plan_btn('payment')
  end

  def change_investor_plan
    change_plan_btn('investor')
  end

  def change_plan_btn(plan)
    is_current = object.plan.eql?(plan)
    is_skip = is_current || has_activation_request?
    options = {}
    options[:class] = %w(btn btn-primary dim btn-outline)
    options[:class].push 'active' if is_current
    options[:class].push 'disabled' if !is_current && has_activation_request?
    href = is_skip ? '' : h.change_plan_user_path(plan: plan)
    if is_skip
      options[:onclick] = 'ChangeUserPlan.skip(event)'
    else
      options[:onclick] = 'ChangeUserPlan.open(event)'
      options[:remote] = true
    end
    name = h.t("plans.#{plan}.name")
    description = h.t("plans.#{plan}.description")
    h.link_to(href, options) do
      [h.content_tag(:div, name, class: 'font-big font-bold'),
       h.content_tag(:div, description, class: 'font-small')].join.html_safe
    end
  end

  def activation_request_button
    h.link_to(I18n.t('plan.request'), '#', onclick: 'ActivationRequestForm.open(event)', class: 'btn btn-danger', id: 'activation_request_btn')
  end

  def activation_send_link
    h.link_to(I18n.t('devise.registrations.activation_request.status.managed.btn'), h.user_activation_request_path, class: 'btn btn-info')
  end

  def has_activation_request?
    object.activation_request.present?
  end

  def activation_pending?
    object.activation_request.try(:pending?)
  end

  def activation_managed?
    object.activation_request.try(:managed?)
  end

  def activation_active?
    object.activation_request.try(:active?)
  end

  def affiliate_link
    h.root_url(ref: affiliate_token) if affiliate_token
  end

  def vizitka_link
    h.vizitka_url(affiliate_token) if affiliate_token
  end

  def affiliate_token
    object.username.presence || object.token
  end

  def plan
    I18n.t("plans.#{object.plan}.name")
  end

  def small_plan?
    object.small?
  end

  def payment_plan?
    object.payment?
  end

  def credit_plan?
    object.credit?
  end

  def show_activation_progress?
    (small_plan? && !base_activated?) || (credit_plan? && (voucher.blank? || !voucher.completed?))
  end

  def pay_activation_amount
    object.purse.pay_activation_amount
  end

  def current_activation_amount
    object.purse.current_activation_amount
  end

  def activation_progress_class(i)
    css = []
    plan_amount = object.plan_system_amount(true)
    amount = self.current_activation_amount
    pay_amount = self.pay_activation_amount
    if pay_amount > plan_amount * i
      css.push 'payed'
    elsif amount >= plan_amount * i
      css.push 'active'
    end
    css.join(' ')
  end

  def activation_progress_width(i)
    plan_amount = object.plan_system_amount(true)
    step_amount = plan_amount * (i + 1)
    amount = self.current_activation_amount
    amount += self.voucher_amount
    if amount > step_amount
      100
    elsif amount > step_amount - plan_amount
      (1 + (amount - step_amount) / plan_amount) * 100
    else
      0
    end
  end

  def small_plan_activation_style(i)
    width = activation_progress_width(i)
    "width: #{width}%"
  end

  def activate_plan_link
    # has_money = object.has_money_by_paid_plan?
    # url = has_money ? h.activate_user_path : '#flash'
    # attrs = has_money ? {method: :post} : {data: {data_type: 'flash', text: I18n.t('plan.deposit_info'), type: 'danger'}}
    # h.link_to_if(object.pending?, I18n.t('plan.activate'), url, attrs.merge({class: 'btn btn-sm btn-success'})){I18n.t('plan.activated')}
    ''
  end

  def show_vouchers_link?
    base_activated? || my_vouchers.present?
  end

  # def free_points
  #   object.free_points.to_i
  # end
  #
  # def free_points_label
  #   h.content_tag(:label, "#{free_points}/300", class: "free-points label label-#{free_points_full? ? 'warning' : 'info'}", title: h.t('free_points_tooltip', scope: 'devise.registrations.edit'))
  # end

  def note_by_voucher_request?
    object.documents.empty? || object.authentications.empty?
  end

  def voucher_request_note
    h.content_tag(:span, I18n.t('note', scope: 'devise.registrations.voucher_request'), class: 'text-success') if note_by_voucher_request?
  end

  def voucher_request_button
    name = note_by_voucher_request? || (has_voucher_request? && object.voucher_request.activated?) ? h.t('plans.credit.name') : h.t('devise.registrations.voucher_request.create')
    href = note_by_voucher_request? || has_voucher_request? ? '' : h.voucher_requests_path
    css = []
    css.push 'active' if credit_plan?
    options = {}
    options[:onclick] = 'ChangeUserPlan.voucher(event)' if note_by_voucher_request? || has_voucher_request?
    h.content_tag(:li, class: css) do
      if note_by_voucher_request? || has_voucher_request?
        h.link_to(name, href, options)
      else
        h.button_to(name, href, options)
      end
    end
  end

  def has_voucher_request?
    object.voucher_request.present?
  end

  def has_investor?
    has_voucher_request? && object.voucher_request.activated?
  end

  def investor_square
    h.image_tag(investor.avatar_url(:source, :square), class: 'img-circle circle-border m-b-md') if has_investor?
  end

  def investor_full_name
    investor.full_name if has_investor?
  end

  def investor_social_links_inspinia
    investor.social_links_inspinia if has_investor?
  end

  def voucher_request_time_progress
    voucher_request.decorate.progress_time_left unless voucher_request.in_progress?
  end

  def voucher_request_progress_expired
    return unless voucher_request.decorate.progress_expired?
    h.content_tag(:div, class: 'widget yellow-bg p-lg text-center') do
      h.content_tag(:div, class: 'm-b-md') do
        h.content_tag(:i, '', class: 'fa fa-warning fa-4x') +
            h.content_tag(:h1, h.t('voucher_requests.states.expired'), class: 'm-xs')+
            h.content_tag(:h3, h.t('voucher_requests.states.expired_full'))
      end
    end.html_safe
  end

  def has_parent?
    object.parent.present?
  end

  def parent_thumb
    decorated_parent.thumb if has_parent?
  end

  def parent_full_name
    decorated_parent.full_name if has_parent?
  end

  # TODO: add save counters with cron

  def statistic_up_date
    I18n.l(Time.zone.today.to_date)
  end

  def children_count
    object.children_count.to_i
  end

  def first_line_count
    children_count # TODO: add second_line
  end

  def account_potential
    activeted_children_count = object.children.real_team.count
    Money.new(activeted_children_count * 3 * 400 * 100, 'USD').format
  end

  def new_children_count
    object.children.recent.count
  end

  def pending_vouchers_count
    object.my_vouchers.pending.count
  end

  def completed_vouchers_count
    object.my_vouchers.completed.count
  end

  # def free_points_full?
  #   free_points >= 300
  # end

  def pending_referral_note
    # pending? ? h.content_tag(:h5, I18n.t('pending_referral_note', max: User::ACCEPTED_INVITATION_LIMIT, scope: 'devise.registrations.edit').html_safe, class: 'text-danger') : ''
  end

  protected

  def investor
    object.voucher_request.owner.decorate
  end

  def decorated_parent
    object.parent.decorate
  end
end
