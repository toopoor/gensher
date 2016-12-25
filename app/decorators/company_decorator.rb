class CompanyDecorator < Draper::Decorator
  delegate_all

  def user_vote
    object.company_votes.by_user(h.current_user).first_or_initialize
  end

  def user_vote_url
    h.company_company_votes_path(object)
  end

  def edit_link
    h.link_to(h.t('companies.actions.edit'), h.edit_company_path(object), class: 'btn btn-xs btn-primary margin-top-10')
  end

  def remove_link
    h.link_to(h.t('companies.actions.remove'), object, remote: true, method: :delete, data: {confirm: h.t('static.are_you_sure')}, class: 'btn btn-xs btn-warning margin-top-10')
  end
end
