class Evaluation < ActiveRecord::Base
  attr_accessible :judge_id, :challenge_id

  belongs_to :challenge
  belongs_to :judge
  has_many :report_cards
  has_many :entries, through: :report_cards

  validates :challenge_id, uniqueness: { scope: :judge_id }

  def status
    # this method return an integer
    # 0: Has not started to evaluate entries
    # 1: Has started but hasn't finished
    # 2: Has finished evaluating this challenge

    # how many entries are left to be evaluated?
    case entries_left_to_evaluate
    when entries.count then 0
    when (1..entries.count-1) then 1
    when 0 then 2
    end
  end

  def number_of_entries_graded
    # let's return the number of entries graded
    report_cards.map { |r| r.criteria_and_grades_are_valid? ? 1 : 0 }.reduce(:+)
  end

  def entries_left_to_evaluate
    entries.count - number_of_entries_graded
  end
end
