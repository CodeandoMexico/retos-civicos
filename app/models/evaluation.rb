class Evaluation < ActiveRecord::Base
  belongs_to :challenge
  belongs_to :judge
  has_many :report_cards
  has_many :entries, through: :report_cards

  validates :challenge_id, uniqueness: { scope: :judge_id }
  after_create :send_email_to_judge

  def initialize_report_cards
    challenge.entries.each { |e| verify_and_create_report_card_from(e) }
  end

  def self_destruct
    report_cards.destroy_all
    destroy
  end

  def finished?
    status == 2
  end

  def status
    # this method return an integer
    # 0: Has not started to evaluate entries
    # 1: Has started but hasn't finished
    # 2: Has finished evaluating this challenge

    # how many entries are left to be evaluated?
    case entries_left_to_evaluate
    when total_number_of_entries then NOT_STARTED_EVALUATING_CHALLENGE
    when (1..total_number_of_entries - 1) then STARTED_EVALUATING_CHALLENGE
    when 0 then FINISHED_EVALUATING_CHALLENGE
    end
  end

  def number_of_entries_graded
    # let's return the number of entries graded
    report_cards.map { |r| r.criteria_and_grades_are_valid? ? 1 : 0 }.reduce(:+) || 0
  end

  def entries_left_to_evaluate
    total_number_of_entries - number_of_entries_graded
  end

  def total_number_of_entries
    report_cards.count
  end

  def verify_and_create_report_card_from(entry)
    new_report_card(entry) if entry.valid_entry?
  end

  private

  def send_email_to_judge
    JudgeMailer.invited_to_challenge(self).deliver
  end

  def new_report_card(entry)
    ReportCard.create! do |r|
      r.evaluation_id = id
      r.entry_id = entry.id
      r.grades = ReportCard.duplicate_criteria(challenge.evaluation_criteria)
    end
  end
end
