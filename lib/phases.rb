module Phases
  def self.entry_added_message(challenge)
    t('phases.entry_added', date: l(challenge.published_on + 31, format: :long))
  end

  private

  def self.t(*args)
    I18n.t(*args)
  end

  def self.l(*args)
    I18n.l(*args)
  end
end
