class PursePayment::PointsController < ApplicationController
  respond_to :html
  before_action :authenticate_user!

  def index
    respond_to do |format|
      format.html
    end
  end
end