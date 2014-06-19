module Phases
  def self.entry_added_message(dates)
    t('phases.entry_added', date: l(dates.ideas_phase_due_on, format: :long))
  end

  def self.for_dates(dates)
    [Phase.of_ideas(dates), Phase.of_ideas_selection(dates)]
  end

  def self.is_current?(phase, dates)
    for_dates(dates).select(&:current?).first.to_s == phase.to_s
  end

  class Phase
    attr_reader :id, :start, :finish

    def initialize(id, start, finish, translator = Phases)
      @id = id
      @start = start.to_date
      @finish = finish.to_date
      @translator = translator
    end

    def self.of_ideas(dates)
      new(:ideas, beginning_of_times, dates.ideas_phase_due_on)
    end

    def self.of_ideas_selection(dates)
      new(:ideas_selection, dates.ideas_phase_due_on, dates.ideas_selection_phase_due_on)
    end

    def to_s
      translator.t("phases.#{id}_phase")
    end

    def current?
      start < current_date && current_date < finish
    end

    private

    def current_date
      Date.current
    end

    def self.beginning_of_times
      Date.new(0,1,1)
    end

    attr_reader :translator
  end

  private

  def self.t(*args)
    I18n.t(*args)
  end

  def self.l(*args)
    I18n.l(*args)
  end
end
