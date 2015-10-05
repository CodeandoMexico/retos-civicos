class OrganizationsController < ApplicationController
  authorize_resource

  def show
    @organization = Organization.find_by_slug(params[:organization_slug])

    if @organization.present?
      # if @organization.has_only_one_challenge?
      #   @challenge = @organization.challenges.active.first
      #   redirect_to @challenge
      # else
        @challenges = @organization.challenges.active
      # end
    else
      # redirect to 404
      return record_not_found
    end
    render layout: 'aquila'
  end

  def edit
    @organization = Organization.find(params[:id])
    render layout: 'aquila'
  end

  def update
    @organization = Organization.find(params[:id])

    if @organization.update_attributes(params[:organization])
      redirect_to dashboard_url, notice: t('flash.organizations.updated')
    else
      render :edit, layout: 'aquila'
    end
  end

  def subscribers_list
    @organization = Organization.find(params[:id])
    @subscribers = @organization.subscribers.order(:id).page(params[:page])
  end
end
