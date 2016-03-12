module Phases
  class NullPhase
    def title(_args = {})
      ''
    end

    def to_s
      ''
    end

    def to_sym
      :''
    end

    def current?
      false
    end

    def days_left
      -1
    end
  end
end
