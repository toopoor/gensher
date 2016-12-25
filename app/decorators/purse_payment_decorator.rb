class PursePaymentDecorator < Draper::Decorator
  delegate_all

  def created_at
    I18n.l(object.created_at, format: :short)
  end

  def purse
    object.purse.decorate.link_to_account
  end

  def source_purse
    (source_purse = object.source_purse).present? ? source_purse.decorate.link_to_account : '-'
  end

  def link_to_payment
    h.link_to(payment_name, url_to_payment, title: object.description)
  end

  def url_to_payment
    h.purse_payment_path(object)
  end

  def payment_name
    object.class.to_name
  end

  def source_payment
    (source_payment = object.source_payment).present? ? self.class.decorate(source_payment).link_to_payment : '-'
  end

  def target
    (target = object.target).present? ? target.decorate.show_link : '-'
  end

  def name
    h.current_user.admin? ? link_to_payment : h.content_tag(:span, object.name, title: object.description)
  end

  def amount
    object.amount.format
  end

  def state
    I18n.t(object.state, scope: 'states')
  end
end
