class MembersController < ApplicationController
  load_and_authorize_resource

  def edit
    render layout: 'aquila'
  end

  def update
    if @member.update_attributes(params[:member])
      @member.confirm! if @member.unconfirmed_email.present?

      if Challenge.count == 1
        @member.collaborations.create(challenge: last_challenge)
        redirect_to new_challenge_entry_path(last_challenge), notice: t('challenges.collaborating')
      else
        redirect_back_or challenges_path, t('flash.members.updated')
      end
    else
      render :edit, layout: 'aquila'
    end
  end
end
