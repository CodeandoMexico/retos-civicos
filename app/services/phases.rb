require 'active_support/all'
require_relative 'phases/dates'
require_relative 'phases/null_phase'
require_relative 'phases/phase'
require_relative 'phases/phases_for_dates'
require_relative 'phases/timeline'

module Phases
  def self.entry_added_message(dates)
    t('entry_added', date: l(dates.ideas_phase_due_on, format: :long))
  end

  def self.prototype_added_message(dates)
    t('prototype_added', date: l(dates.prototypes_phase_due_on, format: :long))
  end

  def self.prototype_edited_message(dates)
    t('prototype_edited', date: l(dates.prototypes_phase_due_on, format: :long))
  end

  def self.timeline_from_dates(dates)
    Timeline.new(for_dates(dates))
  end

  def self.dates
    Dates.members
  end

  def self.is_current?(phase, challenge)
    for_dates(challenge).fetch(phase).current?
  end

  def self.current_phase_title(dates)
    for_dates(dates).current.title
  end

  def self.current_phase_id(dates)
    for_dates(dates).current.id
  end

  def self.completeness_percentage_for(phase, dates)
    for_dates(dates).fetch(phase).completeness_percentage
  end

  def self.days_left_for_current_phase(dates)
    for_dates(dates).current.days_left
  end

  private

  def self.for_dates(challenge)
    PhasesForDates.new(Dates.from_record(challenge))
  end

  def self.t(key, options = {})
    I18n.t("phases.#{key}", options)
  end

  def self.l(key, options = {})
    options = { format: :phases }.merge(options)
    I18n.l(key, options)
  end
end
