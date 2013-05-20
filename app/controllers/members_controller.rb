class MembersController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if @member.update_attributes(params[:member])
      redirect_to challenges_path, notice: t('flash.members.updated')
    else
      render :edit
    end
  end
end
