class MembersController < ApplicationController
  load_and_authorize_resource

  def show
    @member = Member.find(params[:id])
    render layout: 'aquila'
  end

  def edit
    render layout: 'aquila'
  end

  def update
    params.permit!
    if @member.update_attributes(params[:member])
      @member.confirm! if @member.unconfirmed_email.present?
      redirect_back_or member_path(@member), t('flash.members.updated')
    else
      render :edit, layout: 'aquila'
    end
  end
end
