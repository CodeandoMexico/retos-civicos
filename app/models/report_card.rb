class ReportCard < ActiveRecord::Base
  attr_accessible :grades, :evaluation_id, :entry_id

  belongs_to :evaluation
  belongs_to :entry

  serialize :grades, Array

  validate :criteria_is_present, on: :create
  validate :grades_must_be_valid, on: :update

  def grades_must_be_valid
    self.grades.each do |g|
      if grade_is_valid? g[:value]
        return errors.add(:grades, 'Las evaluaciones deben ser un número definido del 0 al 5.')
      end
    end
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

  private

  def grade_is_valid?(grade, min=0, max=5)
    grade.nil? || !grade.is_number? || Integer(grade) < 0 || Integer(grade) > 5
  end
end
