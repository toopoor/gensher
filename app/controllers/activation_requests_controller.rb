class ActivationRequestsController < ApplicationController
  respond_to :html, :js, :json
  before_action :authenticate_user!
  before_action :set_activation_request, only: [:change_plan, :manage, :invoice, :complete, :destroy]
  layout 'inspinia/admin_panel'


  def index; end

  def show
    @activation_request = current_user.activation_request
    @activation_request = @activation_request.decorate
  end

  def list
    @activation_requests = ((@type = params[:type]).present? ? ActivationRequest.send(@type) : ActivationRequest.scoped).ordered.page(params[:page])
    @activation_requests = @activation_requests.decorate

    respond_with(@activation_requests) do |format|
      format.html { render layout: !request.xhr? }
      format.js
    end
  end

  def create
    @activation_request = current_user.create_activation_request(activation_request_params)
    redirect_to edit_user_registration_path
  end

  def update
    @activation_request = current_user.activation_request
    @activation_request.update(activation_request_params)
    redirect_url = @activation_request.managed? ? user_activation_request_path : edit_user_registration_path
    redirect_to(redirect_url)
  end

  def destroy
    @activation_request.destroy if current_user.admin?
  end

  def change_plan
    @activation_request.user.change_plan!(params[:plan]) if @activation_request.can_manage?(current_user)
    @activation_request = @activation_request.decorate
    respond_with(@activation_request) do |format|
      format.js
      format.html { redirect_to(activation_requests_path) }
    end
  end

  def manage
    if @activation_request.can_manage?(current_user)
      @activation_request.update(activation_request_params)
      @activation_request.manage_by!(current_user)
    end
    @activation_request = @activation_request.decorate
    respond_with(@activation_request) do |format|
      format.js
      format.html { redirect_to(activation_requests_path) }
    end
  end

  def invoice
    type = %w(system parent).include?(params[:type]) ? params[:type] : 'parent'
    activation_request_invoice = type.eql?('parent') ? @activation_request.parent_invoice_file : @activation_request.system_invoice_file
    redirect_to(edit_user_registration_path) && return if @activation_request.blank? || activation_request_invoice.blank?
    # TODO: add flash error and can access read
    respond_to do |format|
      format.html {
        activation_request_invoice_path = activation_request_invoice.path
        logger.info("Read activation_request: #{activation_request_invoice_path}")
        send_data( File.open(activation_request_invoice_path).read, type: activation_request_invoice.content_type, disposition: 'inline') }
    end
  end

  def complete
    @activation_request.complete_by!(current_user) if @activation_request.can_manage?(current_user)
    @activation_request = @activation_request.reload
    @activation_request = @activation_request.decorate
    render :manage
  end

  protected

  def set_activation_request
    @activation_request = current_user.admin? ? ActivationRequest.find(params[:id]) : current_user.activation_requests.find(params[:id])
  end

  def activation_request_params
    params.require(:activation_request).permit(:parent_invoice_file, :pay_system, :comment, :system_invoice_file)
  end
end
