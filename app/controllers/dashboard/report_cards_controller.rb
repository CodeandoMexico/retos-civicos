module Dashboard
  class ReportCardsController < Dashboard::BaseController
    before_filter :set_current_challenge

    def index
      @challenges = organization.challenges.sorted
    end

    private

    def set_current_challenge
      @current_challenge = current_challenge
    end
  end
end
