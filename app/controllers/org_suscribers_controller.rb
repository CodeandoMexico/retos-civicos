class OrgSuscribersController < ApplicationController

  def create
    organization = Organization.find(params[:organization_id])
    organization.org_suscribers.create(email: params[:email])
    redirect_to organization, notice: t('flash.organizations.welcome_new_suscriber')
  end

end
