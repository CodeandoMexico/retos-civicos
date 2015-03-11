class ReportCardDecorator < BaseDecorator
  def grade_process(grade, criteria_ponderation)
    return 'N/A' if grade.nil? || criteria_ponderation.nil?

    "#{grade} / #{criteria_ponderation} / #{ReportCard.individual_score(grade, criteria_ponderation)}"
  end
end
