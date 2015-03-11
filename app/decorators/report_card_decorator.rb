class ReportCardDecorator < BaseDecorator
  def grade_process(grade, criteria_ponderation)
    return 'N/A' if grade.nil? || criteria_pondereation.nil?

    "#{grade} / #{ReportCard.individual_score(grade, criteria_ponderation)}"
  end
end
