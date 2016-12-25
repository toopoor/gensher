class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    _provider_sign_in
  end

  def twitter
    _provider_sign_in
  end

  def linkedin
    _provider_sign_in
  end

  def facebook
    _provider_sign_in
  end

  def vkontakte
    _provider_sign_in
  end

  def odnoklassniki
    _provider_sign_in
  end

  # def youtube
  #   _provider_sign_in
  # end

  protected

  def _provider_sign_in
    provider = action_name
    kind = I18n.t(provider, scope: 'devise.omniauth.providers.names')

    parent_token = request.env['affiliate.tag']
    parent = User.find_by(token: parent_token)
    redirect_to(root_path, notice: t('users.registrations.new.registration_only_with_token')) && return if (parent_token.blank? || parent.blank?) && current_user.nil?

    @user = User.connect_to_provider(provider,
                                     request.env['omniauth.auth'],
                                     parent, current_user)

    if current_user
      set_flash_message(:notice, :updated, kind: kind) if is_navigational_format?
      sign_in @user, bypass: true
      redirect_to edit_user_registration_path
    elsif @user.persisted?
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.omniauth_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_path
    end
  end

  def after_omniauth_failure_path_for(scope)
    new_user_session_path
  end
end
