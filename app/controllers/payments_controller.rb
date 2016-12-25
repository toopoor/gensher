class PaymentsController < ApplicationController
  respond_to :html, :js, :json
  before_action :authenticate_user!
  before_action :has_admin_access
  before_action :set_payment, except: [:index, :list]
  layout 'inspinia/admin_panel'

  def index
    respond_with(@payments)
  end

  def list
    @payments = ((@type = params[:type]).present? ? Payment::Base.send(@type) : Payment::Base.all).ordered.page(params[:page])
    @payments = PaymentDecorator.decorate_collection(@payments)

    respond_with(@payments) do |format|
      format.html {render layout: !request.xhr?}
      format.js
    end
  end

  def update
    @payment.update(payment_params)
    respond_with(@payment) do |format|
      format.json { respond_with_bip(@payment) }
    end
  end

  def manage
    @payment.manage! if @payment.update(payment_params)
    @payment = PaymentDecorator.decorate(@payment)
    respond_with(@payment) do |format|
      format.js
      format.html{ redirect_to(payments_path) }
    end
  end

  def invoice
    redirect_to(edit_user_registration_path) and return if (@payment.blank? || @payment.invoice_file.blank?) && !(current_user.admin? && @payment.user.eql?(current_user) )
    #TODO add flash error and can access read && add cancan
    respond_to do |format|
      format.html {
        payment_invoice_path = @payment.invoice_file.path
        logger.info("Read activation_request: #{payment_invoice_path}")
        send_data( File.open(payment_invoice_path).read, type: @payment.invoice_file.content_type, disposition: 'inline') }
    end
  end

  def cancel
    @payment.cancel! if @payment.pending?
    @payment = PaymentDecorator.decorate(@payment)
    respond_with(@payment) do |format|
      format.js
    end
  end

  def complete
    @payment.complete! if @payment.to_complete?(current_user)
    @payment = PaymentDecorator.decorate(@payment)
    respond_with(@payment) do |format|
      format.js
    end
  end

  protected
  def set_payment
    @payment = Payment::Base.find_by(token: params[:id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :comment)
  end
end