class EvaluationsController < Dashboard::BaseController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!
  before_filter :require_current_challenge, only: :index
  before_filter :set_judge_and_evaluation, only: [:index, :edit, :update]

  def index
    @challenges = @judge.challenges.order('created_at DESC')
    @entries = current_challenge_entries
    @current_phase = Phases.current_phase_title(current_challenge)
  end

  def edit
  end

  def update
    if @evaluation.update_attributes(params[:evaluation])
      redirect_to evaluations_path
    else
      render :edit
    end
  end

  private

  def authenticate_judge!
    redirect_to challenges_path unless current_user.judge?
  end

  def current_challenge_entries
    default = current_challenge.entries.order('created_at DESC').includes(:challenge, member: :user)

    if params[:filter] == 'accepted'
      default.accepted
    else
      default
    end
  end

  def set_judge_and_evaluation
    @judge = current_user.userable
    @evaluation = @judge.evaluations.find_by_challenge_id(current_challenge.id)
    @current_challenge = current_challenge
  end

end
