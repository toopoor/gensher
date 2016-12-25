class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js, :json

  before_action :set_plan_to_session, only: [:new]
  before_action :parent_token, only: [:new, :create]

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = if update_needs_confirmation?(resource, prev_unconfirmed_email)
                      :update_needs_confirmation
                    else
                      :updated
                    end
        set_flash_message :notice, flash_key
      end

      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource) do |format|
        format.html
        format.json { render json: resource }
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def update_resource(resource, params)
    if params[:password].blank?
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      super
    end
  end

  def build_resource(hash = nil)
    self.resource = @parent.children.build(hash || {})
    resource.invited_by = @parent
    resource.plan = session[:reg_plan] if session[:reg_plan].present?
  end

  def parent_token
    set_parent_token
    redirect_to(root_path, notice: t('users.registrations.new.registration_only_with_token')) && return unless @parent
  end

  def set_plan_to_session
    return if params[:plan].blank?
    return unless resource_class.plans.keys.include?(params[:plan])
    session[:reg_plan] = params[:plan]
  end
end
