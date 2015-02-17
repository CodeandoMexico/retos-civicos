class ReportCard < ActiveRecord::Base
  attr_accessible :grades, :evaluation_id, :entry_id

  belongs_to :evaluation
  belongs_to :entry

  serialize :grades, Array

  validate :criteria_is_present, on: :create
  validate :validate_grades, on: :update

  def average_score
    max_score = 5.0
    total_score = 0

    if criteria_is_present && grades_are_present? && grades_are_valid?
      self.grades.each_with_index do |g, idx|
        individual_score = (Integer(g[:value]) / max_score) * Integer(self.evaluation.challenge.evaluation_criteria[idx][:value])
        total_score = total_score + individual_score
      end

      average_score = total_score / self.evaluation.challenge.evaluation_criteria.length
    else
      nil
    end
  end

  def validate_grades
    return errors.add(:grades, 'Las evaluaciones deben ser un número definido del 0 al 5.') if !grades_are_valid?
  end

  def grades_are_present?
    self.grades.present?
  end

  def criteria_is_present
    self.evaluation.challenge.evaluation_criteria.present?
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
      self.grades.each do |g|
        if grade_is_invalid? g[:value]
          return false
        end
      end
      return true
    end
    false
  end

  private

  def grade_is_invalid?(grade, min=0, max=5)
    grade.nil? || !grade.is_number? || Integer(grade) < 0 || Integer(grade) > 5
  end
end
