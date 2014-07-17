module Phases
  class Timeline
    Start = Struct.new(:date, :title)

    def initialize(phases, translator = Phases)
      @phases = phases
      @translator = translator
    end

    def start
      Start.new(translator.l(phases.ideas.start), translator.t('start'))
    end

    def ideas
      @ideas ||= phases.fetch(:ideas).to_struct
    end

    def ideas_selection
      @ideas_selection ||= phases.fetch(:ideas_selection).to_struct
    end

    def prototypes
      @prototypes ||= phases.fetch(:prototypes).to_struct
    end

    def prototypes_selection
      @prototypes_selection ||= phases.fetch(:prototypes_selection).to_struct
    end

    private

    attr_reader :phases, :translator
  end
end
