class CollaborationsController < ApplicationController
  load_resource :challenge
  load_and_authorize_resource through: :current_member

  def create
    redirect_to organization_challenge_path(@challenge.organization, @challenge), notice: t('challenges.collaborating')
  end
end
