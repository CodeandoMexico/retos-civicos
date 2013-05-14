class OrganizationsController < ApplicationController

  def edit
    @organization = current_user.userable
  end

  def update
    @organization = current_user.userable
    if @organization.update_attributes(params[:organization])
      redirect_to challenges_path, notice: t('flash.organizations.updated')
    else
      render :edit
    end
  end

end
