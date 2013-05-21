class OrganizationsController < ApplicationController
  load_and_authorize_resource 

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

end
