class MembersController < ApplicationController
  load_and_authorize_resource

  def edit
    @member = current_member
  end

  def update
    @member = current_member
    if @member.update_attributes(params[:member])
      redirect_to challenges_path, notice: t('flash.members.updated')
    else
      render :edit
    end
  end
end
