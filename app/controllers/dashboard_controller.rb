class DashboardController < ApplicationController
  layout 'dashboard'

  before_filter :authenticate_organization_admin!

  def show
    @challenges = top_five(organization_challenges)
    @entries = top_five(organization_entries)
  end

  private

  def organization_challenges
    organization.challenges.includes(:collaborators, :entries)
  end

  def organization_entries
    Entry.where(challenge_id: organization.challenge_ids).
      includes(:challenge, member: :user)
  end

  def top_five(relation)
    relation.order('created_at DESC').limit(5)
  end

  def organization
    current_user.userable
  end

  def authenticate_organization_admin!
    unless current_user
      redirect_to challenges_path
    end
  end
end
