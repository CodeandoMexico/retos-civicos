module Phases
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

    def self.of_prototypes_selection(dates)
      new(:prototypes_selection, dates.prototypes_phase_due_on, dates.finish_on)
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
end
