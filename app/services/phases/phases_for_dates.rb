module Phases
  class PhasesForDates
    attr_reader :ideas, :ideas_selection, :prototypes, :prototypes_selection

    def initialize(dates)
      @ideas = Phase.of_ideas(dates)
      @ideas_selection = Phase.of_ideas_selection(dates)
      @prototypes = Phase.of_prototypes(dates)
      @prototypes_selection = Phase.of_prototypes_selection(dates)
    end

    def fetch(phase)
      all.fetch(phase)
    end

    def current
      all.values.select(&:current?).first || NullPhase.new
    end

    private

    def all
      { ideas: ideas,
        ideas_selection: ideas_selection,
        prototypes: prototypes,
        prototypes_selection: prototypes_selection }
    end
  end
end
