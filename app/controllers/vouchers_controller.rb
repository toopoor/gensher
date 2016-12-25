class VouchersController < ApplicationController
  respond_to :html, :js, :json
  before_action :authenticate_user!
  before_action :has_admin_access, only: :destroy

  def list
    @vouchers = current_user.admin? ? Voucher::Base : current_user.my_vouchers
    @vouchers = ((@type = params[:type]).present? ? @vouchers.send(@type) : @vouchers).ordered.page(params[:page])
    @type ||= 'all'
    @vouchers = VoucherDecorator.decorate_collection(@vouchers)

    respond_with(@vouchers) do |format|
      format.html { render layout: !request.xhr? }
      format.js
    end
  end

  def destroy
    @voucher = Voucher::Base.find params[:id]
    @voucher.destroy
  end
end
