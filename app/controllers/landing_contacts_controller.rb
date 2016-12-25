class LandingContactsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def index

  end

  def create
    @landing_contact = LandingContact.new(landing_contact_params)
    token = Subdomain.get_subdomain(request)
    @landing_contact.partner = User.find_by(token: token)
    @landing_contact.ip_address = request.remote_ip
    if @landing_contact.save
      render status: :ok, text: t('.save_success')
    else
      render status: :bad_request, text: t('.save_error')
    end
  end

  def read

  end

  def destroy

  end

  protected

  def set_landing_contact

  end

  def landing_contact_params
    params.require(:landing_contact).permit(:name, :email, :phone, :address, :message)
  end
end