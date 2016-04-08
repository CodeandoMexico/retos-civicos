module Dashboard
  class JudgesController < Dashboard::BaseController
    before_filter :require_current_challenge, only: [:index, :new, :create]
    before_filter :set_current_challenge
    load_and_authorize_resource
    add_crumb 'Jurado'

    def index
      @challenges = organization.challenges.order('created_at DESC')
      @judges = current_challenge_judges
      respond_to do |format|
        format.html do
          set_flash_for_index
        end
        format.csv { send_data @current_challenge.export_evaluations, filename: 'propuestas_por_juez.csv' }
      end
    end

    def show
      @judge = Judge.find(params[:id])
      @evaluation = Evaluation.find_by_judge_id_and_challenge_id(@judge, @current_challenge)
    end

    def new
      @user = User.new
    end

    def create
      if create_new_user
        current_challenge.evaluations.create!(judge_id: @user.userable.id).initialize_report_cards
        notice_text = t('flash.judge.saved_successfully')
        redirect_to dashboard_judges_path(challenge_id: @current_challenge), notice: notice_text
      else
        render :new
      end
    end

    private

    def current_challenge_judges
      current_challenge.judges.order('created_at DESC')
    end

    def set_current_challenge
      @current_challenge = current_challenge
    end

    def set_flash_for_index
      unless @current_challenge.criteria_must_be_present
        flash.now[:alert] = t('flash.challenges.criteria.critieria_has_not_been_defined_yet')
      end
      unless @current_challenge.evaluations_opened
        flash.now[:warning] = t('flash.challenges.evaluation.evaluation_has_been_closed')
      end
    end

    def create_new_user
      @user = User.new(params[:user])
      @user.password = User.reset_password_token
      @user.reset_password_token = User.reset_password_token
      @user.reset_password_sent_at = Time.now
      @user.userable = Judge.new
      @user.skip_confirmation!
      JudgeMailer.new_account(@user).deliver if @user.save
    end
  end
end
