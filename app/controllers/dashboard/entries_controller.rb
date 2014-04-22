module Dashboard
  class EntriesController < Dashboard::BaseController
    def index
      @challenges = organization.challenges.order('created_at DESC')
      @current_challenge = @challenges.find_by_id(params[:challenge_id]) || @challenges.first
      @entries = @current_challenge.entries.order('created_at DESC').includes(:challenge, member: :user)
    end
  end
end
