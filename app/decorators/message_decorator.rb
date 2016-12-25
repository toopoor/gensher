class MessageDecorator < Draper::Decorator
  delegate_all

  def owner
    object.user ? object.user.decorate : nil
  end

  def subject_link
    h.link_to(object.subject, object)
  end

  def user
    if owner
      owner.short_name
    else
      'guest'
    end
  end

  def status
    h.icon(object.is_active ? 'check-square text-success' : 'check-square text-muted')
  end

  def icon
    h.icon(case object.message_type
           when 'support'
             'support text-danger'
           when 'feedback'
             'bullhorn text-warning'
           when 'news'
             'exclamation-circle text-success'
             when 'news_system'
               'exclamation-triangle text-danger'
         end)
  end

  def time
    I18n.l(object.created_at, format: :long)
  end
end
