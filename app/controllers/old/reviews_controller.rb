class Old::ReviewsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js, :json
  include TheSortableTreeController::ExpandNode

  before_action :has_admin_access

  def index
    @reviews = Old::Review.published.joins(:user).page(params[:page]).per(10)
  end

  def migrate
    @review = Old::Review.published.joins(:user).find(params[:id])
    logger.debug(@review.inspect)
    if @user = User.find_by_email(@review.user.email)

      message = Message.new(message_type: 'feedback', subject: @review.user.fio, body: @review.content, created_at: @review.date)
      message.user = @user
      message.valid?
      logger.debug(message.inspect)
      logger.debug(message.errors.full_messages.inspect)
      logger.debug(@user.inspect)


      @review.destroy if message.save
    end
  end

end
