class OrganizationsController < ApplicationController
  load_and_authorize_resource except: [:add_suscriber]

  def show
  end

  def edit
  end

  def update
    if @organization.update_attributes(params[:organization])
      redirect_to new_organization_challenge_path(@organization), notice: t('flash.organizations.updated')
    else
      render :edit
    end
  end

  def add_suscriber
    @organization = Organization.find(params[:id])
    @organization.org_suscribers.create(email: params[:email])
    redirect_to @organization, notice: t('flash.organizations.welcome_new_suscriber')
  end

end
