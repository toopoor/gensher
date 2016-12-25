class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard, :stats]
  layout 'inspinia/admin_panel', except: :index

  def index
    set_parent_token
    respond_to do |format|
      format.html { render layout: 'inspinia/empty' }
    end
  end

  def dashboard
    @activities = PublicActivity::Activity.order(id: :desc)
    unless current_user.admin?
      children_ids = current_user.children.map(&:id)
      @activities = @activities.where(trackable_type: 'User',
                                      trackable_id: children_ids)
    end
    @activities = @activities.page(params[:page]).per(10)

    respond_to do |format|
      format.html { render layout: 'inspinia/admin_panel' }
    end
  end

  def stats
    @my_team = current_user.children.count
    @first_line = User.first_line(current_user).count
    @invitations_count = current_user.invitations.count
    @invitations_count_inactive = User.inactive_invited(current_user).count
  end

  def feedback
    @informe = Informe.new
    @contact = Contact.new
  end

  def terms; end

  def privacy; end

  def marketing; end

  def notify
    # TODO msg_type (support|feedback)
    # TODO store all messages in one table

    @delivered = false

    @contact = Contact.new(contact_params)

    if @contact.deliver
      flash.now[:delivered] = 'Message was succesfully sent!'
      @delivered = true
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js {}
    end
  end

  def contact_params
    params[:contact].permit(:name, :email, :phone, :message)
  end
end
