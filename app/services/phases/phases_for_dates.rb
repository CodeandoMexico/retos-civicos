module Phases
  class PhasesForDates
    attr_reader :ideas, :ideas_selection, :prototypes, :prototypes_selection

    def initialize(dates)
      @ideas = Phase.of_ideas(dates)
      @ideas_selection = Phase.of_ideas_selection(dates)
      @prototypes = Phase.of_prototypes(dates)
      @prototypes_selection = Phase.of_prototypes_selection(dates)
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
      current.present? && current.to_sym == phase.to_sym
    end

    def present_current
      (current || NullPhase.new).present
    end

    def fetch(phase)
      all.fetch(phase)
    end

    private

    def all
      { ideas: ideas,
        ideas_selection: ideas_selection,
        prototypes: prototypes,
        prototypes_selection: prototypes_selection }
    end

    def current
      all.values.select { |phase| phase.current? }.first
    end
  end
end
