class EntryDecorator < BaseDecorator
  def owner_name
    if member.name.present?
      member.name
    else
      member.email
    end
  end

  def score
    challenge.finished_evaluating? ? final_score : I18n.t('entries.not_available')
  end
end
