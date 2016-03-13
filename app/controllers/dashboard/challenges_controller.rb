module Dashboard
  class ChallengesController < Dashboard::BaseController
    before_filter :set_challenge, only: [:new_criteria, :create_criteria, :close_evaluation]
    load_and_authorize_resource

    def index
      add_crumb 'Retos', '/dashboard/retos'
      @challenges = organization.challenges
                                .order('created_at DESC').includes(:collaborators, :entries)
    end

    def new
      add_crumb 'Retos', '/dashboard/retos'
      add_crumb 'Nuevo'
    end

    def edit
      add_crumb 'Retos', '/dashboard/retos'
      add_crumb 'Editar'
      @activity = @challenge.activities.build
    end

    def create
      @challenge = organization.challenges.new(params[:challenge])
      if @challenge.save
        redirect_to dashboard_challenges_path
      else
        render :new
      end
    end

    def update
      if @challenge.update_attributes(params[:challenge])
        redirect_to dashboard_challenges_path
      else
        render :edit
      end
    end

    def new_criteria
      add_crumb 'Jurado', '/dashboard/jueces'
      add_crumb 'Definición de criterios'
    end

    def create_criteria
      @challenge.evaluation_criteria = fetch_criteria
      @challenge.evaluation_instructions = params[:evaluation_instructions]

      if @challenge.evaluation_instructions.present? && @challenge.save
        notice = t('flash.challenges.criteria.criteria_successfully_defined')
        redirect_to dashboard_judges_path(challenge_id: @challenge.id), notice: notice
      else
        flash_text = t('flash.challenges.criteria.please_check_that_all_criteria_fields_for_any_errors')
        flash.now[:alert] = flash_text
        render :new_criteria
      end
    end

    def close_evaluation
      if @challenge.close_evaluation
        notice = t('flash.challenges.evaluation.evaluation_successfully_closed')
        redirect_to dashboard_judges_path(challenge_id: @challenge.id), notice: notice
      else
        alert_text = t('flash.challenges.evaluation.evaluation_could_not_be_closed')
        redirect_to dashboard_judges_path(challenge_id: @challenge.id), alert: alert_text
      end
    end

    private

    def fetch_criteria
      params[:criteria].map { |c| c.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo } }
    end

    def set_challenge
      @challenge = Challenge.find(params['challenge_id'])
    end
  end
end
