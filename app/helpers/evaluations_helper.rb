module EvaluationsHelper
  def humanize_evaluation_status(status)
    case status
    when 0
      # Has not started to evaluate entries
      I18n.t('evaluations.status.has_no_started')
    when 1
      # Has started but hasn't finished
      I18n.t('evaluations.status.still_evaluating')
    when 2
      # Has finished evaluating this challenge
      I18n.t('evaluations.status.finished')
    end
  end
end
