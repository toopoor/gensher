class PursePayment::ActivationsController < ApplicationController
  respond_to :html, :js
  before_action :authenticate_user!
  layout 'inspinia/admin_panel'

  def index
    respond_to do |format|
      format.html
    end
  end

  def list
    @type = params[:type] || 'all'
    @activations = current_user.purse_payments.activations(@type).page(params[:page])
    @activations = PursePaymentDecorator.decorate_collection(@activations)

    respond_to do |format|
      format.html {render layout: !request.xhr?}
      format.js
    end
  end
end