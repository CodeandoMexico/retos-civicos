class EvaluationsController < Dashboard::BaseController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!
  before_filter :require_current_challenge, only: :index

  def index
    @judge = current_user.userable
    @challenges = @judge.challenges.order('created_at DESC')
    @current_challenge = current_challenge
    @entries = current_challenge_entries
    @current_phase = Phases.current_phase_title(current_challenge)
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

end
