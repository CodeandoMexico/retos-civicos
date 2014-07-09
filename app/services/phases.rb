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

  class Timeline
    Start = Struct.new(:date, :title)
    Phase = Struct.new(:completeness, :title, :due_date, :due_date_title)

    def initialize(phases, translator)
      @phases = phases
      @translator = translator
    end

    def start
      Start.new l(phases.ideas.start), t('start')
    end

    def ideas
      @ideas ||= struct_for :ideas
    end

    def ideas_selection
      @ideas_selection ||= struct_for :ideas_selection
    end

    def prototypes
      @prototypes ||= struct_for :prototypes
    end

    private

    def struct_for(phase)
      Phase.new(
        phases.completeness_percentage_for(phase),
        phases.present(phase),
        l(phases.finish_of(phase)),
        t("#{phase}_due_date_title"))
    end

    def t(path)
      translator.t("phases.#{path}")
    end

    def l(date)
      translator.l(date, format: :phases_bar)
    end

    attr_reader :phases, :translator
  end

  class PhasesForDates
    attr_reader :ideas, :ideas_selection, :prototypes

    def initialize(dates)
      @ideas = Phase.of_ideas(dates)
      @ideas_selection = Phase.of_ideas_selection(dates)
      @prototypes = Phase.of_prototypes(dates)
    end

    def present(phase)
      fetch(phase).present
    end

    def completeness_percentage_for(phase)
      fetch(phase).completeness_percentage
    end

    def finish_of(phase)
      fetch(phase).finish
    end

    def current?(phase)
      raise 'All phases have been completed, maybe you need a new phase' unless current
      current.to_sym == phase.to_sym
    end

    private

    def all
      { ideas: ideas,
        ideas_selection: ideas_selection,
        prototypes: prototypes }
    end

    def fetch(phase)
      all.fetch(phase)
    end

    def current
      all.values.select(&:current?).first
    end
  end

  class Phase
    attr_reader :id, :start, :finish

    def initialize(id, start, finish, translator = Phases)
      @id = id.to_sym
      @start = start.to_date
      @finish = finish.to_date
      @translator = translator
    end

    def self.of_ideas(dates)
      new(:ideas, dates.starts_on, dates.ideas_phase_due_on)
    end

    def self.of_ideas_selection(dates)
      new(:ideas_selection, dates.ideas_phase_due_on, dates.ideas_selection_phase_due_on)
    end

    def self.of_prototypes(dates)
      new(:prototypes, dates.ideas_selection_phase_due_on, dates.prototypes_phase_due_on)
    end

    def present
      to_s.capitalize
    end

    def to_s
      translator.t("phases.#{id}_phase")
    end

    def to_sym
      id
    end

    def current?
      (start..finish).cover? current_date
    end

    def completeness_percentage
      return 0 if current_date < start
      return 100 if current_date > finish

      (elapsed_days.to_f / total_days.to_f) * 100
    end

    private

    def elapsed_days
      current_date - start
    end

    def total_days
      finish - start
    end

    def current_date
      Date.current
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
