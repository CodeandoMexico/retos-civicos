class EvaluationsController < Dashboard::BaseController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!
  before_filter :require_current_challenge, only: :index
  before_filter :set_judge_and_evaluation, only: [:index, :start]
  before_filter :set_entry, only: :index

  def index
    @challenges = @judge.challenges.order('created_at DESC')
    # @entries = current_challenge_entries
    # @entries = @evaluation.challenge.entries
    @current_phase = Phases.current_phase_title(current_challenge)

    if @entry
      @report_card = ReportCard.find_or_create_by_evaluation_id_and_entry_id(evaluation_id: @evaluation, entry_id: @entry) do |report_card|
        report_card.grades = @entry.challenge.evaluation_criteria
      end
    end
  end

  private

  def authenticate_judge!
    redirect_to challenges_path unless current_user.judge?
  end

  # def current_challenge_entries
  #   default = current_challenge.entries.order('created_at DESC').includes(:challenge, member: :user)
  #
  #   if params[:filter] == 'accepted'
  #     default.accepted
  #   else
  #     default
  #   end
  # end

  def set_entry
    @entry = Entry.find(params[:next] || params[:prev])
    if params[:next]
      @entry = @entry.next
    elsif params[:prev]
      @entry = @entry.prev
    end

    @entry ||= @evaluation.challenge.entries.order("id ASC").first
  end

  def set_judge_and_evaluation
    @judge = current_user.userable
    @current_challenge = current_challenge
    @evaluation = @judge.evaluations.find_by_challenge_id(@current_challenge.id)
  end
end
