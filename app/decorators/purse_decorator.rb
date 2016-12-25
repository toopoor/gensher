class PurseDecorator < Draper::Decorator
  delegate_all

  def link_to_account
    object.system? || !h.current_user.admin? ? account.full_name : account.link_to_profile
  end

  protected
  def account
    (object.system_account || object.user).decorate
  end
end
