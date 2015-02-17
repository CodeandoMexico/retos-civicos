module EvaluationHelpers
  def evaluate(entry, grade)
    expect(page).to have_content entry.name
    set_criteria_fields_to grade
    click_on I18n.t('evaluations.evaluation_criteria.save_criteria')
    expect(page).to have_content I18n.t('report_cards.evaluation_has_ben_saved_successfully')
    expect(page).to have_content grade
  end

  def evaluate_all_entries_with(judge, evaluation, entries, grade=5)
    entries.map do |e|
      create :report_card,
             evaluation_id: evaluation.id,
             entry_id: e.id,
             grades: fetch_new_grades(evaluation.challenge, grade)
    end
  end

  private

  def fetch_new_grades(challenge, grade_for_each_criteria)
    grades = ReportCard.duplicate_criteria(challenge.evaluation_criteria)
    grades.map { |g| g[:value] = grade_for_each_criteria }
  end
end
