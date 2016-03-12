module EvaluationsHelper
  def evaluation_status(status, entries_evaluated = 0, total_entries = 0)
    case status
    when 0
      # Has not started to evaluate entries
      I18n.t('evaluations.status.has_not_started')
    when 1
      # Has started but hasn't finished
      I18n.t('evaluations.status.still_evaluating', entries_evaluated: entries_evaluated, total_entries: total_entries)
    when 2
      # Has finished evaluating this challenge
      I18n.t('evaluations.status.finished')
    end
  end
end
