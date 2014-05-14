class OrganizationsController < ApplicationController
  authorize_resource

  def show
    @organization = Organization.find_by_slug(params[:organization_slug])

    if @organization.has_only_one_challenge?
      @challenge = @organization.challenges.active.first
      redirect_to @challenge
    else
      @challenges = @organization.challenges.active
    end
  end

  def edit
    @organization = Organization.find(params[:id])
    render layout: 'aquila'
  end

  def update
    @organization = Organization.find(params[:id])

    if @organization.update_attributes(params[:organization])
      redirect_to new_organization_challenge_path(@organization), notice: t('flash.organizations.updated')
    else
      render :edit, layout: 'aquila'
    end
  end

  def subscribers_list
    @organization = Organization.find(params[:id])
    @subscribers = @organization.subscribers.order(:id).page(params[:page])
  end
end
