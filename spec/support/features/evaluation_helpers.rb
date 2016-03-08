module EvaluationHelpers
  def evaluate(entry, grade, opts={})
    expect(page).to have_content entry.name
    set_criteria_fields_to grade
    set_comments_and_feedback_with(opts)
    click_on I18n.t('evaluations.evaluation_criteria.save_criteria')
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

  def update_criteria_fields
    10.times { |idx| all(:css, "#criteria__description")[idx].set("New criteria #{idx+1}") }
    click_on 'Guardar'
  end

  #  Navigation links
  def page_should_have_next_entry_link
    expect(page).to have_content I18n.t('evaluations.index.next_entry')
  end

  def page_should_have_prev_entry_link
    expect(page).to have_content I18n.t('evaluations.index.previous_entry')
  end

  def page_should_not_have_next_entry_link
    expect(page).to_not have_content I18n.t('evaluations.index.next_entry')
  end

  def page_should_not_have_prev_entry_link
    expect(page).to_not have_content I18n.t('evaluations.index.previous_entry')
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

  def set_criteria_fields_to(grade)
    10.times { |idx| all(:css, "#grades__value")[idx].set(grade) }
  end

  def set_comments_and_feedback_with(opts)
    comments = opts[:comments]
    feedback = opts[:feedback]
    find(:css, "#comments").set(comments) if comments
    find(:css, "#feedback").set(feedback) if feedback
  end
end
