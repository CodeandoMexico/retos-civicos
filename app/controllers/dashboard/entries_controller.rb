module Dashboard
  class EntriesController < Dashboard::BaseController
    def index
      @challenges = organization_challenges
      @current_challenge = current_challenge
      @entries = current_challenge.entries.order('created_at DESC').includes(:challenge, member: :user)
    end

    private

    def organization_challenges
      @organization_challenges ||= organization.challenges.active.order('created_at DESC')
    end

    def current_challenge
      @current_challenge ||= begin
        organization_challenges.find_by_id(params[:challenge_id]) ||
          organization_challenges.first
      end
    end
  end
end
