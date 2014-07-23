module Dashboard
  class MailersController < Dashboard::BaseController
    # before_filter :require_current_challenge, only: :new

    def new
      @challenges = organization_challenges
      @current_challenge = current_challenge
      @collaborators = current_challenge_collaborators
    end

    def create
      raise "Reached create"
    end

    private

    def current_challenge_collaborators
      current_challenge.collaborations.
        includes(:member).
        order('created_at DESC').
        map(&:member).
        compact
    end
  end
end
