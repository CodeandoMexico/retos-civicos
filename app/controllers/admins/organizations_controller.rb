class Admins::OrganizationsController < Admins::BaseController

  def index
    @organizations = Organization.all
  end

end
