class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  include PublicActivity::StoreController
  before_action :check_subdomain

  layout :layout_by_resource

  protected

  def has_admin_access
    redirect_to root_path, alert: I18n.t('access.failed') && return unless admin?
  end

  def check_subdomain
    logger.info("Subdomain #{request.subdomain}")
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone, :email, :skype,
                                                       :plan, :password,
                                                       :password_confirmation,
                                                       :remember_me])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :phone, :email,
                                                       :skype, :password,
                                                       :remember_me])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:phone, :email,
                                             :skype, :password,
                                             :password_confirmation,
                                             :current_password, :username,
                                             :first_name, :last_name,
                                             :middle_name, :skype, :address,
                                             :avatar, :remove_avatar, :about_me,
                                             :success_story,
                                             :crop_x, :crop_y,
                                             :crop_w, :crop_h])
    devise_parameter_sanitizer.permit(:accept_invitation,
                                      keys: [:phone, :plan, :skype, :password,
                                             :password_confirmation,
                                             :invitation_token])
  end

  def set_parent_token
    return unless (@parent_token = request.env['affiliate.tag']).present?
    @parent = User.find_by(token: @parent_token)
  end

  def admin?
    current_user.try(:admin?)
  end

  def current_user
    super.try(:decorate)
  end

  def layout_by_resource
    if devise_controller? && !user_signed_in?
      'inspinia/empty'
    else
      'inspinia/admin_panel'
    end
  end
end
