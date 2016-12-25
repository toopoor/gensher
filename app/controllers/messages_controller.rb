class MessagesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:feedback]
  before_action :set_message, only: [:show, :edit, :update, :destroy, :toggle_active]
  layout 'inspinia/admin_panel'

  # GET /messages
  # GET /messages.json
  def index
    type = params[:message_type]
    @sysnews = Message.sysnews.joins(:user).first if type.eql?('news')
    @messages = messages(type)
    @messages = @messages.joins(:user)
    @messages = @messages.page(params[:page]).per(5)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = @message.decorate
  end

  # GET /messages/new
  def new
    @message = Message.new(message_type: params[:message_type])
  end

  # GET /messages/1/edit
  def edit; end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    @message.user = current_user
    respond_to do |format|
      if @message.save
        format.html { redirect_to root_path, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_active
    return unless admin?
    @message.toggle!(:is_active)
    @message = @message.decorate
  end

  def feedback
    @messages = Message.joins(:user).public_feedback.page(params[:page]).per(5)
    render 'index'
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:message_type, :subject, :body)
  end

  def messages(type)
    return Message.mynews(current_user) if type.eql?('news')
    return Message.conference if type.eql?('conference')
    return Message if admin?
    return current_user.messages if type.blank?
    current_user.messages.message_type(type)
  end
end
