class EvaluationsController < Dashboard::BaseController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!
  before_filter :require_current_challenge, only: :index
  before_filter :set_judge_and_evaluation, only: [:index, :start]

  def index
    @challenges = @judge.challenges.order('created_at DESC')
    @entries = current_challenge_entries
    @current_phase = Phases.current_phase_title(current_challenge)
  end

  def start
    # Prepare all the evaluations so that we can evaluate them
    # raise @current_challenge
    @entries = @evaluation.challenge.entries
    if @current_challenge.evaluation_criteria.present?
      ReportCard.initialize_from_entries(@evaluation, @entries)
    else
      redirect_to evaluations_path(challenge_id: @current_challenge.id),
        alert: I18n.t('flash.judge.criteria_has_not_been_set_for_this_challenge', email: @current_challenge.organization.email)
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
    @current_challenge = current_challenge
    @evaluation = @judge.evaluations.find_by_challenge_id(@current_challenge.id)
  end
end
