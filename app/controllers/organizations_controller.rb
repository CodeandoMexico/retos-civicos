class OrganizationsController < ApplicationController

  before_filter :load_organization
  authorize_resource

  def show
    if @organization.has_only_one_challenge?
      @challenge = @organization.challenges.first
      redirect_to @challenge
    else
      @challenges = @organization.challenges.active
    end
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
