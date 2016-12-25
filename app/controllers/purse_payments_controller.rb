class PursePaymentsController < ApplicationController
  respond_to :html, :js
  before_action :authenticate_user!
  before_action :has_admin_access
  layout 'inspinia/admin_panel'

  def index
    respond_with(@purse_payments)
  end

  def list
    @purse_payments = ((@type = params[:type]).present? ? PursePayment::Base.send(@type) : PursePayment::Base.all).ordered.page(params[:page])
    @purse_payments = PursePaymentDecorator.decorate_collection(@purse_payments)

    respond_with(@payments) do |format|
      format.html {render layout: !request.xhr?}
      format.js
    end
  end

  def show
    @purse_payment = PursePayment::Base.find(params[:id]).decorate
    respond_with(@purse_payment)
  end
end