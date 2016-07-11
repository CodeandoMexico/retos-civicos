class EvaluationsController < Dashboard::BaseController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!
  before_filter :require_current_challenge, only: :index
  before_filter :set_judge_and_current_challenge, only: [:index, :show]
  before_filter :set_challenges, only: [:index, :show]
  before_filter :set_report_card, only: :index
  before_filter :set_evaluation, only: :index

  def index
    return unless !@current_challenge.evaluations_opened? || (@evaluation.finished? && !params[:edit])
    redirect_to evaluation_url(@evaluation, challenge_id: @current_challenge.id)
  end

  def show
    @evaluation = Evaluation.find(params[:id])
    @report_cards = ReportCard.where(evaluation_id: @evaluation.id)
  end

  private

  def set_report_card
    @report_card = if params[:report_card_id]
                     ReportCard.find(params[:report_card_id])
                   else
                     evaluation = @judge.evaluations.find_by_challenge_id(@current_challenge.id)
                     ReportCard.where(evaluation_id: evaluation).order('id ASC').first
                   end
    authorize! :read, @report_card if @report_card.present?
  end

  def authenticate_judge!
    redirect_to challenges_path unless current_user.judge?
  end

  def set_judge_and_current_challenge
    @judge = current_user.userable
    @current_challenge = current_challenge
  end

  def set_evaluation
    @evaluation = @judge.evaluations.find_by_challenge_id(@current_challenge.id)
  end

  def set_challenges
    @challenges ||= @judge.challenges.order('created_at DESC')
  end
end
