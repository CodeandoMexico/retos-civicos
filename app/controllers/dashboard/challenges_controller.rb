module Dashboard
  class ChallengesController < Dashboard::BaseController
    before_filter :set_challenge, only: [:new_criteria, :create_criteria]
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

    def new_criteria
      add_crumb 'Jurado', '/dashboard/jueces'
      add_crumb 'Definición de criterios'
      return unless @challenge.evaluation_criteria.blank?
      @challenge.evaluation_criteria = Array.new(12, description: nil, value: nil)
    end

    def create_criteria
      @challenge.evaluation_criteria = fetch_criteria
      @challenge.evaluation_instructions = params[:evaluation_instructions]

      if @challenge.evaluation_instructions.present? && @challenge.save
        redirect_to dashboard_judges_path(challenge_id: @challenge.id), notice: t('flash.challenges.criteria.criteria_successfully_defined')
      else
        flash.now[:alert] = t('flash.challenges.criteria.please_check_that_all_criteria_fields_for_any_errors')
        render :new_criteria
      end
    end

    private

    def fetch_criteria
      params[:criteria].map{ |c| c.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} }
    end

    def set_challenge
      @challenge = Challenge.find(params['challenge_id'])
    end
  end
end
