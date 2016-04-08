class MembersController < ApplicationController
  load_and_authorize_resource

  def show
    render layout: 'aquila'
  end

  def edit
    render layout: 'aquila'
  end

  def update
    if @member.update_attributes(params[:member])
      @member.confirm! if @member.unconfirmed_email.present?
      redirect_back_or challenges_path, t('flash.members.updated')
    else
      render :edit, layout: 'aquila'
    end
  end
end
