class Payment::CashDepositsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js
  before_action :set_payment, only: [:show, :cancel, :update]
  layout 'inspinia/admin_panel'

  def index
    @cash_deposits = PaymentDecorator.decorate_collection(current_user.payment_cash_deposits.pending_manage)
    respond_with(@cash_deposits)
  end

  def show
    @cash_deposit = PaymentDecorator.decorate(@cash_deposit)
    respond_with(@cash_deposit)
  end

  def new
    @cash_deposit = current_user.payment_cash_deposits.new(payer_id: 'advcash')
    respond_with(@cash_deposit)
  end

  def create
    @cash_deposit = current_user.payment_cash_deposits.new(payment_params)
    respond_to do |format|
      if @cash_deposit.save
        format.html { redirect_to payment_cash_deposit_path(@cash_deposit), notice: I18n.t('payment.cash_deposits.create.cash_deposit_was_successfully_created') }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @cash_deposit.update(invoice_params)
    @cash_deposit = PaymentDecorator.decorate(@cash_deposit)
    render :show
  end

  def cancel
    @cash_deposit.cancel! if @cash_deposit.pending?
    respond_with(@cash_deposit)
  end

  protected

  def set_payment
    @cash_deposit = (current_user.admin? ? Payment::CashDeposit : current_user.payment_cash_deposits).find_by(token: params[:id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :payer_id)
  end

  def invoice_params
    params.require(:payment).permit(:invoice_file)
  end
end
