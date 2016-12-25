class PursePayment::VouchersController < ApplicationController
  respond_to :html, :js
  before_action :authenticate_user!
  layout 'inspinia/admin_panel'

  def index
    redirect_to(edit_user_registration_path) and return unless current_user.base_activated? || current_user.my_vouchers.present?
    respond_to do |format|
      format.html
    end
  end

  def create
    type = params[:type]
    return if (voucher_class = Voucher.class_type(type)).blank?
    count = begin
      Kernel::Integer(params[:count])
    rescue
      error = I18n.t('vouchers.errors.count_zero')
      0
    end
    error = I18n.t('vouchers.errors.no_money_in_purse') if count > current_user.vouchers_max(type)
    if error.present?
      flash[:danger] = error
      render action: :index
    else
      Array.new(count).map { voucher_class.create(owner: current_user) }
      flash[:notice] = I18n.t('vouchers.success_create')
      redirect_to action: :index
    end
  end
end
