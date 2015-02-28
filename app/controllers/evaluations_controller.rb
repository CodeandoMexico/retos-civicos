class EvaluationsController < Dashboard::BaseController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!
  before_filter :require_current_challenge, only: :index
  before_filter :set_judge_and_evaluation, only: [:index, :start]
  before_filter :set_entry, only: :index

  def index
    @challenges = @judge.challenges.order('created_at DESC')
    @report_card = fetch_report_card(@evaluation, @entry) if @entry
  end

  private

  def fetch_report_card(evaluation, entry)
    ReportCard.find_by_evaluation_id_and_entry_id(evaluation, entry) # ||
    # the create should be only be used as a fail safe, for instance an entry which
    # has been manually created, in theory this code should be seldom used
    # this is a prone to errors with misuse
    # ReportCard.create! do |r|
    #   r.evaluation_id = evaluation.id
    #   r.entry_id = entry.id
    #   r.grades = ReportCard.duplicate_criteria(evaluation.challenge.evaluation_criteria)
    # end
  end

  def authenticate_judge!
    redirect_to challenges_path unless current_user.judge?
  end

  def set_entry
    @entries ||= @evaluation.challenge.entries

    if params[:entry_id]
      @entry = Entry.find(params[:entry_id])
      fetch_navigation_entries
    elsif @entries.any?
      @entry = @entries.order("id ASC").first
      fetch_navigation_entries
    end
  end

  def set_judge_and_evaluation
    @judge = current_user.userable
    @current_challenge = current_challenge
    @evaluation = @judge.evaluations.find_by_challenge_id(@current_challenge.id)
  end

  def fetch_navigation_entries
    @next_entry = @entry.next
    @prev_entry = @entry.prev
  end
end
