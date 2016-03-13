class CollaborationsController < ApplicationController
  load_and_authorize_resource

  def create
    @challenge = Challenge.find(params[:challenge_id])
    @collaboration = current_member.collaborations.build(challenge: @challenge)
    if @collaboration.save
      notice = t('challenges.collaborating')
      redirect_to new_challenge_entry_path(@challenge), notice: notice
    else
      notice = t('challenges.collaborating_error')
      redirect_to organization_challenge_path(@challenge.organization, @challenge), notice: notice
    end
  end
end
