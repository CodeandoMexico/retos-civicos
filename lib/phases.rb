module Phases
  def self.entry_added_message(challenge)
    t('phases.entry_added', date: l(challenge.ideas_phase_due_on, format: :long))
  end

  def self.of_challenge(challenge)
    [Phase.of_ideas(challenge), Phase.of_ideas_selection(challenge)]
  end


  class Phase
    attr_reader :id, :start, :finish

    def initialize(id, start, finish, translator = Phases)
      @id = id
      @start = start
      @finish = finish
      @translator = translator
    end

    def self.of_ideas(challenge)
      new(:ideas,
          :start,
          challenge.ideas_phase_due_on)
    end

    def self.of_ideas_selection(challenge)
      new(:ideas_selection,
          challenge.ideas_phase_due_on,
          challenge.ideas_selection_phase_due_on)
    end

    def to_s
      translator.t("phases.#{id}_phase")
    end

    def current?
      start < Date.current < finish
    end

    private

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
