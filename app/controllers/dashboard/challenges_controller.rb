module Dashboard
  class ChallengesController < Dashboard::BaseController
    before_filter :set_challenge, only: [:new_criteria, :create_criteria]

    def index
      @challenges = organization.challenges.
        order('created_at DESC').includes(:collaborators, :entries)
    end

    def new_criteria
      if @challenge.evaluation_criteria.blank?
        @challenge.evaluation_criteria = Array.new(10, {description: nil, value: nil})
      end
    end

    def create_criteria
      @challenge.evaluation_criteria = params[:criteria]

      if @challenge.save
        redirect_to dashboard_judges_path(challenge_id: @challenge.id), notice: t('flash.challenges.criteria.criteria_successfully_defined')
      else
        flash.now[:alert] = t('flash.challenges.criteria.please_check_that_all_criteria_fields_for_any_errors')
        render :new_criteria
      end
    end

    private
    def set_challenge
      @challenge = Challenge.find(params["challenge_id"])
    end
  end
end
