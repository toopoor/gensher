class InstrumentsController < ApplicationController
  before_action :authenticate_user!, except: [:vizitka]
  layout 'inspinia/admin_panel'

  def first_line
    @users = current_user.first_line
    download if params[:download]
  end

  def invited
    @users = current_user.invitations
    @type = params[:type]
    @users = case @type
             when 'pending'
               @users.invitation_not_accepted
             when 'accepted'
               @users.invitation_accepted
             else
               @users
             end
    if params[:download]
      download
    else
      @users = @users.page(params[:page])
    end
  end

  private

  def download
    phones = @users.where.not(phone: ['', nil])
                   .uniq.pluck(:phone, :last_name, :first_name)
                   .map { |d| [d[0].tr('+', ''), [d[1], d[2]].join(' ')] }
                   .map { |d| d.join("\t") }
                   .join("\r\n")
    send_data phones, filename: 'phones.txt', disposition: :attachment
  end
end
