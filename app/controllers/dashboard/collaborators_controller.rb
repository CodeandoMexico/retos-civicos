module Dashboard
  class CollaboratorsController < Dashboard::BaseController
    def index
      @challenges = organization_challenges
      @current_challenge = current_challenge
      @collaborators = current_challenge_collaborators
    end

    private

    def current_challenge_collaborators
      current_challenge.collaborations.
        includes(:member).
        order('created_at DESC').
        map &:member
    end
  end
end
