class OrganizationsController < ApplicationController

  before_filter :load_organization
  authorize_resource

  def show
    @challenges = @organization.challenges
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
