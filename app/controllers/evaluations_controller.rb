class EvaluationsController < Dashboard::BaseController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!
  before_filter :require_current_challenge, only: :index
  before_filter :set_judge_and_challenge, only: [:index, :start]
  before_filter :set_report_card, only: :index

  def index
    @challenges = @judge.challenges.order('created_at DESC')
  end

  private

  def set_report_card
    @report_card = if params[:report_card_id]
      ReportCard.find(params[:report_card_id])
    else
      evaluation = @judge.evaluations.find_by_challenge_id(@current_challenge.id)
      ReportCard.where(evaluation_id: evaluation).order('id ASC').first
    end
  end

  def authenticate_judge!
    redirect_to challenges_path unless current_user.judge?
  end

  def set_judge_and_challenge
    @judge = current_user.userable
    @current_challenge = current_challenge
  end
end
