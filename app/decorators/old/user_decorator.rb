class Old::UserDecorator < Draper::Decorator
  delegate_all

  def link_to_complete
    object.imported? ?
      h.link_to(h.icon('check'), h.complete_old_user_path(object), remote: true, method: :post, title: I18n.t('static.complete'), class: 'btn btn-xs btn-info') : ''
  end

  def link_to_destroy
    h.link_to(h.icon('ban'), object, remote: true, method: :delete, title: I18n.t('static.destroy'), data: {confirm: I18n.t('static.are_you_sure')}, class: 'btn btn-xs btn-danger')
  end

  def tree_show
    Old::User::PUBLIC_ATTRS.map{|attr| h.best_in_place(object, attr)}.join('').html_safe
  end

  def tree_controls
    h.content_tag(:div, class: 'actions'){
      (link_to_complete + link_to_destroy).html_safe
    }
  end
end