class UsersController < ApplicationController
  include TheSortableTreeController::Rebuild
  include TheSortableTreeController::ExpandNode

  before_action :authenticate_user!
  before_action :has_admin_access, only: [:index, :complete_form, :complete, :complete_close]
  before_action :set_user, only: [:profile, :complete_form, :complete, :complete_close]
  respond_to :html, :js
  layout 'inspinia/admin_panel'

  def index
    @users = User.includes(:authentications, :documents)
    @users = @users.where(search_user_params) unless params[:user].blank?
    @users = @users.ordered if current_user.admin?
    @users = @users.in_progress if params[:in_progress].present?
    @users = @users.has_money if params[:has_money].present?
    @users = @users.page(params[:page]).per(10)
  end

  def profile
    @user = @user.decorate
    respond_with(@user)
  end

  def change_plan
    @user = current_user
    if @user.activation_request.present?
      redirect_to(edit_user_registration_path,
                  error: t('plan.no_access_to_change')) && return
    end
    @user.change_plan!(params[:plan])
    @plans = User.plans.keys
  end

  def update_plan
    new_plan = params[:plan]
    @user = current_user
    if %w(small payment credit).include?(new_plan) &&
       @user.activation_request.blank?
      @user.update(plan: new_plan)
      msg = { notice: t('plan.change_success') }
    else
      msg = { error: t('plan.no_access_to_change') }
    end
    redirect_to(edit_user_registration_path, msg)
  end

  # def activate
  #   @user = current_user
  #   flash_msg = @user.has_money_by_paid_plan? && @user.activate! ? {notice: I18n.t('plan.activate_success')} : {alert: I18n.t('plan.deposit_info')}
  #   respond_with(@user) do |format|
  #     format.html{ redirect_to edit_user_registration_path, flash_msg}
  #   end
  # end

  def complete_voucher
    @user = User.find(params[:id])
    flash_msg = if current_user.admin? && Voucher::Base.next.present?
                  @user.complete_with_credit!
                  { notice: I18n.t('vouchers.success_complete') }
                else
                  { aleft: I18n.t('vouchers.errors.complete') }
                end

    respond_with(@user) do |format|
      format.html { redirect_to users_path, flash_msg }
    end
  end

  # def complete_form
  #   respond_with(@user)
  # end

  # def complete
  #   amount = -Money.new(params[:amount].to_i*100)
  #   @user.activate_with_credit!(amount)
  #   @user = @user.reload.decorate
  #   respond_with(@user)
  # end

  # def complete_close
  #   @user = @user.decorate
  #   respond_with(@user)
  # end

  def first_line
    @users = current_user.first_line
    respond_with(@users)
  end

  def invited
    @users = current_user.invitations
    @type = params[:type]

    @users = case @type
             when 'pending'
               @users.invitation_not_accepted
             when 'accepted'
               @users.invitation_accepted
             else
               @users
             end

    @users = @users.page(params[:page])
    respond_with(@users)
  end

  def structure
    @users = current_user.first_line
    respond_with(@users)
  end

  def login_as
    return if !current_user.admin? && session[:admin_id].blank?
    admin_id = current_user.id if current_user.admin?

    user = User.find(params[:id])
    if session[:admin_id].eql?(params[:id])
      session.delete(:admin_id)
    end

    bypass_sign_in(user, scope: :user)
    session[:admin_id] = admin_id
    redirect_to root_url, notice: "Вы авторизированы как #{user.username}"
  end

  protected

  def set_user
    @user = User.find(params[:id])
  end

  def search_user_params
    permit_params = params.require(:user).permit(:email)
    permit_params.compact!
  end
end
