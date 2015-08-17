class EntryDecorator < BaseDecorator
  def owner_name
    if member.company_name.present?
      member.company_name
    elsif member.name.present?
      member.name
    else
      member.email
    end
  end

  def score
    self.challenge.finished_evaluating? ? self.final_score : I18n.t('entries.not_available')
  end
end
