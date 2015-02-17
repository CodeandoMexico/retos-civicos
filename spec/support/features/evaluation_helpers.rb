module EvaluationHelpers
  def evaluate(entry, grade)
    expect(page).to have_content entry.name
    set_criteria_fields_to grade
    click_on I18n.t('evaluations.evaluation_criteria.save_criteria')
    expect(page).to have_content I18n.t('report_cards.evaluation_has_ben_saved_successfully')
    expect(page).to have_content grade
  end
end
