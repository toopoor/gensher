class Old::UsersController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js, :json
  include TheSortableTreeController::Rebuild
  include TheSortableTreeController::ExpandNode

  before_action :has_admin_access
  before_action :set_user, except: [:index]

  def index
    @users = Old::User.nested_set.active.root.children
    respond_with(@users)
  end

  def update
    @user.update(user_params)
    respond_with(@user) do |format|
      format.json { respond_with_bip(@user) }
    end
  end

  def complete
    user = User.where('email = ? or phone = ?', @user.email, @user.tel).first
    if user.present?
      @notice = I18n.t('users.import.taked')
    else
      @user.to_user(current_user)
    end
    respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end

  public
  def sortable_model
    Old::User
  end

  private
  def set_user
    @user = Old::User.find(params[:id])
  end

  def user_params
    params.require(:old_user).permit(*Old::User::PUBLIC_ATTRS)
  end

end