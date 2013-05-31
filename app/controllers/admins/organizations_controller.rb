class Admins::OrganizationsController < Admins::BaseController

  def index
    @organizations = Organization.all
  end

  def accept
    @organization = Organization.find(params[:id])
    @organization.update_attribute :accredited, true
    redirect_to admins_organizations_path
  end

end
