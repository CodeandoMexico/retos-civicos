require 'active_support/all'
require_relative '../../lib/phases'

module Phases
  describe 'phases of challenge' do
    ChallengeRecord = Struct.new(:ideas_phase_due_on, :ideas_selection_phase_due_on)


    it 'has an ideas phase' do
      phases = Phases.of_challenge(ChallengeRecord.new)
      phases.map(&:to_s).should include 'ideas'
    end

    it 'has an ideas selection phase' do
      phases = Phases.of_challenge(ChallengeRecord.new)
      phases.map(&:to_s).should include 'selección de ideas'
    end

    it 'has just one current phase' do
      challenge = ChallengeRecord.new(1.day.from_now.to_date, 2.days.from_now.to_date)
      phases = Phases.of_challenge(ChallengeRecord.new)
      phases.select(&:current?).count.should eq 1
    end
  end
end
