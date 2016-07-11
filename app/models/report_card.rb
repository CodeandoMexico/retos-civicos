class ReportCard < ActiveRecord::Base
  attr_accessible :grades, :comments, :feedback, :evaluation_id, :entry_id

  serialize :grades, Array

  # associations
  belongs_to :evaluation
  belongs_to :entry

  # validations
  validate :criteria_is_present, on: :create
  validate :validate_grades, on: :update

  def next
    evaluation.report_cards.where('id > ?', id).order('id ASC').first
  end

  def previous
    evaluation.report_cards.where('id < ?', id).order('id ASC').last
  end

  def total_score
    sum_grades if criteria_and_grades_are_valid?
  end

  def average_score
    compute_average_score(sum_grades) if criteria_and_grades_are_valid?
  end

  def compute_average_score(total_score)
    total_score / evaluation.challenge.evaluation_criteria.length
  end

  def validate_grades
    return errors.add(:grades, 'Las evaluaciones deben ser un número definido del 0 al 5.') unless grades_are_valid?
  end

  def criteria_and_grades_are_valid?
    criteria_is_present && grades_are_present? && grades_are_valid?
  end

  def grades_are_present?
    grades.present?
  end

  def criteria_is_present
    evaluation.challenge.evaluation_criteria.present?
  end

  def self.duplicate_criteria(criteria)
    criteria.map do |c|
      grade = c.deep_dup
      grade[:value] = nil
      grade
    end
  end

  def grades_are_valid?
    if grades_are_present?
      grades.each do |g|
        return false if grade_is_invalid? g[:value]
      end
      return true
    end
    false
  end

  def update_criteria_description(new_criteria)
    grades.each_with_index do |g, idx|
      g[:description] = new_criteria[idx][:description]
    end
    update_attribute('grades', grades)
  end

  def self.individual_score(entry_grade, challenge_evaluation_criteria)
    Integer(entry_grade) / MAX_EVALUATION_SCORE * Integer(challenge_evaluation_criteria)
  end

  private

  def sum_grades
    total_score = 0
    grades.each_with_index do |g, idx|
      total_score += self.class.individual_score(g[:value], evaluation.challenge.evaluation_criteria[idx][:value])
    end
    total_score
  end

  def grade_is_invalid?(grade, _min = 0, _max = 5)
    grade.nil? || !String(grade).is_number? || Integer(grade) < 0 || Integer(grade) > 5
  end
end
