class AuthenticationsController < ApplicationController
  before_action :authenticate_user!
  respond_to :js

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    respond_with(@authentication)
  end
end