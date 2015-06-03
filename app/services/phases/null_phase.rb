module Phases
  class NullPhase
    def title(args = {})
      ""
    end

    def to_s
      ""
    end

    def to_sym
      :''
    end

    def current?
      false
    end

    def days_left
      Float::NAN
    end
  end
end
