module Phases
  def self.entry_added_message(dates)
    t('phases.entry_added', date: l(dates.ideas_phase_due_on, format: :long))
  end

  def self.prototype_added_message(dates)
    t('phases.prototype_added', date: l(dates.prototypes_phase_due_on, format: :long))
  end

  def self.prototype_edited_message(dates)
    t('phases.prototype_edited', date: l(dates.prototypes_phase_due_on, format: :long))
  end

  def self.timeline_from_dates(dates)
    Timeline.new(for_dates(dates), self)
  end

  def self.for_dates(dates)
    PhasesForDates.new(dates)
  end

  def self.is_current?(phase, dates)
    for_dates(dates).current?(phase)
  end

  def self.current(dates)
    for_dates(dates).present_current
  end

  def self.completeness_percentage_for(phase, dates)
    for_dates(dates).completeness_percentage_for(phase)
  end

  private

  def self.t(*args)
    I18n.t(*args)
  end

  def self.l(*args)
    I18n.l(*args)
  end
end
