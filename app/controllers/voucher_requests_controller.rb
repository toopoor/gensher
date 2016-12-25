class VoucherRequestsController < ApplicationController
  respond_to :html, :js, :json
  before_action :authenticate_user!
  before_action :set_voucher_request, only: [:activate, :cancel, :reject]
  layout 'inspinia/admin_panel'

  def index
    @count = Voucher::Base.pending.count
  end

  def list
    @voucher_requests = ((@type = params[:type]).present? ? VoucherRequest.send(@type) : VoucherRequest.scoped).ordered.page(params[:page])
    @voucher_requests = @voucher_requests.decorate

    respond_with(@voucher_requests) do |format|
      format.html {render layout: !request.xhr?}
      format.js
    end
  end

  def create
    @voucher_request = current_user.create_voucher_request
    redirect_to edit_user_registration_path
  end

  def activate
    @voucher_request.activate! if @voucher_request.can_activate?(current_user)
    @voucher_request = @voucher_request.decorate
  end

  def cancel
    @voucher_request.cancel! if @voucher_request.can_manage?(current_user)
    @voucher_request = @voucher_request.decorate
    render :activate
  end

  def reject
    @voucher_request.reject! if @voucher_request.can_manage?(current_user)
    @voucher_request = @voucher_request.decorate
    render :activate
  end

  protected
  def set_voucher_request
    @voucher_request = current_user.admin? ? VoucherRequest.find(params[:id]) : current_user.voucher_requests.find(params[:id])
  end
end