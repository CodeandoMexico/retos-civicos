class Admins::OrganizationsController < Admins::BaseController

  def index
    @organizations = Organization.all
  end

  def accept
    @organization = Organization.find(params[:id])
    @organization.accredit!
    redirect_to admins_organizations_path, notice: t('flash.admins.organizations.accredited')
  end

end
