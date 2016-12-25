class LandingsController < ApplicationController
  skip_before_action :authenticate_user!
  layout -> { layouts_by(@template) }
  before_action :set_user

  def index
    @template = @user.lending_type
    @rewiews = Review.by_landing.decorate
  end

  private

  def set_user
    if (token = params[:token].presence || request.subdomain).present? && (@user = User.find_by(token: token)).present?
      @user = @user.decorate
    else
      subdomain = Rails.env.staging? ? 'staging' : nil
      redirect_to(root_url(subdomain: subdomain), notice: 'Incorrect subdomain. Page not found!') && return
    end
  end

  def layouts_by(template)
    template.eql?('zero') ? 'inspinia/empty' : "landings/#{template}"
  end
end
