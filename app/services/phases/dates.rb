module Phases
  Dates = Struct.new(
    :starts_on,
    :ideas_phase_due_on,
    :ideas_selection_phase_due_on,
    :prototypes_phase_due_on,
    :finish_on) do

      def self.from_record(record)
        new(*members.map { |member| record.send(member) })
      end
    end
end
