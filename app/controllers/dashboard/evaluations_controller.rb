module Dashboard
  class EvaluationsController < Dashboard::BaseController
    before_filter :set_challenge
    before_filter :set_judge, only: :create

    def new
    end

    def show
    end

    def request_permission_for_challenge
      @user = User.find_by_email(params[:email])
      @judge = @user.userable if @user && @user.judge?

      if @user
        if @user.judge?
          render :show
        else
          # user is a collaborator or an organization
          redirect_to new_dashboard_judge_path(challenge_id: @challenge), alert: t('flash.judge.user_cannot_be_added_as_a_judge')
        end
      else
        redirect_to new_dashboard_judge_path(challenge_id: @challenge), alert: t('flash.judge.does_not_exist')
      end
    end

    def create
      if Evaluation.where(judge_id: @judge.id, challenge_id: @challenge.id).empty?
        @challenge.evaluations.create(judge_id: @judge.id)
        redirect_to dashboard_judges_path, notice: t('flash.judge.added_succesfully_for_this_challenge')
      else
        redirect_to new_dashboard_judge_path(challenge_id: @challenge), alert: t('flash.judge.evaluation_already_exists_for_this_challenge')
      end
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

    def set_judge
      @judge = Judge.find(params["judge_id"])
    end
  end
end
