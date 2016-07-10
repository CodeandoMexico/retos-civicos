class DashboardController < Dashboard::BaseController
  layout 'dashboard'
  before_filter :authenticate_organization!

  def show
    @challenges = top_five(organization_challenges)
    @entries = top_five(organization_entries).map { |e| EntryDecorator.new(e) }
  end

  private

  def organization_challenges
    organization.challenges.includes(:collaborators, :entries)
  end

  def organization_entries
    Entry.where(challenge_id: organization.challenge_ids).includes(:challenge, member: :user)
  end

  def top_five(relation)
    relation.order('created_at DESC').limit(5)
  end

  def authenticate_organization!
    redirect_to challenges_path unless current_user.organization?
  end
end
