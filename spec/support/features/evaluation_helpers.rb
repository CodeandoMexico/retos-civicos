module EvaluationHelpers
  def evaluate(entry, grade)
    expect(page).to have_content entry.name
    set_criteria_fields_to grade
    click_on I18n.t('evaluations.evaluation_criteria.save_criteria')
    expect(page).to have_content I18n.t('report_cards.evaluation_has_ben_saved_successfully')
    expect(page).to have_content grade
  end

  def evaluate_all_entries_with(evaluation, entries, grade=5, number_of_entries_to_evaluate=nil)
    report_cards = []
    if number_of_entries_to_evaluate.nil?
      entries.map do |e|
        report_cards << new_report_card({
            evaluation: evaluation,
            entry: e,
            challenge: evaluation.challenge,
            grade: grade
          })
      end
    elsif number_of_entries_to_evaluate > 0
      (number_of_entries_to_evaluate).times do |idx|
        report_cards << new_report_card({
            evaluation: evaluation,
            entry: entries[idx],
            challenge: evaluation.challenge,
            grade: grade
          })
      end
    end
    report_cards
  end

  private

  def new_report_card(args)
    create :report_card,
           evaluation_id: args.fetch(:evaluation).id,
           entry_id: args.fetch(:entry).id,
           grades: fetch_new_grades(args.fetch(:challenge), args.fetch(:grade))
  end

  def fetch_new_grades(challenge, grade_for_each_criteria)
    grades = ReportCard.duplicate_criteria(challenge.evaluation_criteria)
    grades.map { |g| g[:value] = grade_for_each_criteria; g }
  end
end
