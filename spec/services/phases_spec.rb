require 'active_support/all'
require_relative '../../app/services/phases'

module Phases
  describe 'phases for dates' do
    attr_reader :dates

    Dates = Struct.new(
      :created_at,
      :ideas_phase_due_on,
      :ideas_selection_phase_due_on,
      :prototypes_phase_due_on)

    before do
      I18n.default_locale = :es
      I18n.load_path << File.expand_path('../../config/locales/phases.es.yml', File.dirname(__FILE__))
      @dates = Dates.new(1.year.ago, 1.day.from_now, 2.days.from_now, 3.days.from_now)
    end

    it 'has an ideas phase' do
      phases = Phases.for_dates(dates)
      phases.map(&:to_s).should include 'ideas'
    end

    it 'has an ideas selection phase' do
      phases = Phases.for_dates(dates)
      phases.map(&:to_s).should include 'selección de ideas'
    end

    it 'has just one current phase' do
      dates = Dates.new(1.year.ago, 1.day.from_now, 2.days.from_now, 3.days.from_now)
      phases = Phases.for_dates(dates)
      current = phases.select(&:current?)

      current.count.should eq 1
      current.first.to_s.should eq 'ideas'

      dates = Dates.new(1.year.ago, 1.day.ago, 2.days.from_now, 3.days.from_now)
      phases = Phases.for_dates(dates)
      current = phases.select(&:current?)

      current.count.should eq 1
      current.first.to_s.should eq 'selección de ideas'
    end
  end

  describe 'is current' do
    it 'returns true if the asked phase is current' do
      dates = Dates.new(1.year.ago, 1.day.from_now, 2.days.from_now, 3.days.from_now)
      Phases.is_current?(:ideas, dates).should be
      Phases.is_current?(:ideas_selection, dates).should_not be

      dates = Dates.new(1.year.ago, 1.day.ago, 2.days.from_now, 3.days.from_now)
      Phases.is_current?(:ideas, dates).should_not be
      Phases.is_current?(:ideas_selection, dates).should be
    end
  end
end
