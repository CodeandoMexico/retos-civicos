module Phases
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
end
