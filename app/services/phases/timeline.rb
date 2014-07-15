module Phases
  class Timeline
    Start = Struct.new(:date, :title)

    def initialize(phases, translator = Phases)
      @phases = phases
      @translator = translator
    end

    def start
      Start.new(
        translator.l(phases.ideas.start),
        translator.t('start'))
    end

    def ideas
      @ideas ||= phases.struct_for(:ideas)
    end

    def ideas_selection
      @ideas_selection ||= phases.struct_for(:ideas_selection)
    end

    def prototypes
      @prototypes ||= phases.struct_for(:prototypes)
    end

    def prototypes_selection
      @prototypes_selection ||= phases.struct_for(:prototypes_selection)
    end

    private

    attr_reader :phases, :translator
  end
end
