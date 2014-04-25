module Dashboard
  class ChallengesController < Dashboard::BaseController
    def index
      @challenges = organization.challenges.
        order('created_at DESC').includes(:collaborators, :entries)
    end
  end
end
