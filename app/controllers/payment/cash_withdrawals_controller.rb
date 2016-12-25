class Payment::CashWithdrawalsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js
  before_action :set_payment, only: [:show, :cancel, :update]
  layout 'inspinia/admin_panel'

  def index
    @cash_withdrawals = PaymentDecorator.decorate_collection(current_user.payment_cash_withdrawals.pending_manage)
    respond_with(@cash_withdrawals)
  end

  def show
    @cash_withdrawal = PaymentDecorator.decorate(@cash_withdrawal)
    respond_with(@cash_withdrawal)
  end

  def new
    @cash_withdrawal = current_user.payment_cash_withdrawals.new(payer_id: 'advcash')
    respond_with(@cash_withdrawal)
  end

  def create
    @cash_withdrawal = current_user.payment_cash_withdrawals.new(payment_params)
    respond_to do |format|
      if @cash_withdrawal.save
        format.html { redirect_to payment_cash_withdrawal_path(@cash_withdrawal), notice: I18n.t('payment.cash_withdrawals.create.cash_withdrawal_was_successfully_created') }
      else
        format.html { render :new }
      end
    end
  end

  def cancel
    @cash_withdrawal.cancel! if @cash_withdrawal.pending?
    respond_with(@cash_withdrawal)
  end

  protected

  def set_payment
    @cash_withdrawal = (current_user.admin? ? Payment::CashWithdrawal : current_user.payment_cash_withdrawals).find_by(token: params[:id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :payer_id, :comment)
  end
end
