class EvaluationsController < Dashboard::BaseController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!
  before_filter :require_current_challenge, only: :index
  before_filter :set_judge_and_evaluation, only: [:index, :start]
  before_filter :set_entry, only: :index

  def index
    @challenges = @judge.challenges.order('created_at DESC')
    @current_phase = Phases.current_phase_title(current_challenge)
    @report_card = fetch_report_card(@evaluation, @entry) if @entry
  end

  private

  def fetch_report_card(evaluation, entry)
    ReportCard.find_by_evaluation_id_and_entry_id(evaluation, entry) ||
    ReportCard.create! do |r|
      r.evaluation_id = evaluation.id
      r.entry_id = entry.id
      r.grades = ReportCard.duplicate_criteria(evaluation.challenge.evaluation_criteria)
    end
  end

  def authenticate_judge!
    redirect_to challenges_path unless current_user.judge?
  end

  def set_entry
    @entries ||= @evaluation.challenge.entries

    if params[:entry_id]
      @entry = Entry.find(params[:entry_id])
      @next_entry = @entry.next
      @prev_entry = @entry.prev
    elsif @entries.any?
      @entry = @entries.order("id ASC").first
      @next_entry = @entry.next
      @prev_entry = @entry.prev
    end
  end

  def set_judge_and_evaluation
    @judge = current_user.userable
    @current_challenge = current_challenge
    @evaluation = @judge.evaluations.find_by_challenge_id(@current_challenge.id)
  end
end
