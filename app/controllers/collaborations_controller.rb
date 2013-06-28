class CollaborationsController < ApplicationController
  load_and_authorize_resource 

  def create
    @challenge = Challenge.find(params[:challenge_id])
    @collaboration = current_member.collaborations.build(challenge: @challenge)
    if @collaboration.save
      redirect_to organization_challenge_path(@challenge.organization, @challenge), notice: t('challenges.collaborating')
    else
      redirect_to organization_challenge_path(@challenge.organization, @challenge), notice: t('challenges.collaborating_error')
    end
  end
end
