# :nodoc:
class Users::InvitationsController < Devise::InvitationsController
  layout 'inspinia/admin_panel'

  protected

  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    resource.parent = resource.invited_by
    resource
  end
end
