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
      phases.present(:ideas).should eq 'Ideas'
    end

    it 'has an ideas selection phase' do
      phases = Phases.for_dates(dates)
      phases.present(:ideas_selection).should eq 'Selección de ideas'
    end

    it 'has a prototypes phase' do
      phases = Phases.for_dates(dates)
      phases.present(:prototypes).should eq 'Prototipos'
    end

    it 'has a current phase' do
      dates = Dates.new(1.year.ago, 1.day.from_now, 2.days.from_now, 3.days.from_now)
      phases = Phases.for_dates(dates)
      phases.current?(:ideas).should be_true

      dates = Dates.new(1.year.ago, 1.day.ago, 2.days.from_now, 3.days.from_now)
      phases = Phases.for_dates(dates)
      phases.current?(:ideas_selection).should be_true
    end

    describe 'phase completeness percentage' do
      it 'when ideas phase is at 60%' do
        dates = Dates.new(6.days.ago, 4.days.from_now, many_days_from_now, many_days_from_now)
        phases = Phases.for_dates(dates)
        phases.completeness_percentage_for(:ideas).should eq 60
        phases.completeness_percentage_for(:ideas_selection).should eq 0
        phases.completeness_percentage_for(:prototypes).should eq 0
      end

      it 'when ideas selection is at 30%' do
        dates = Dates.new(many_days_ago, 3.days.ago, 7.days.from_now, many_days_from_now)
        phases = Phases.for_dates(dates)
        phases.completeness_percentage_for(:ideas).should eq 100
        phases.completeness_percentage_for(:ideas_selection).should eq 30
        phases.completeness_percentage_for(:prototypes).should eq 0
      end

      it 'when prototypes is at 70%' do
        dates = Dates.new(many_days_ago, many_days_ago, 7.days.ago, 3.days.from_now)
        phases = Phases.for_dates(dates)
        phases.completeness_percentage_for(:ideas).should eq 100
        phases.completeness_percentage_for(:ideas_selection).should eq 100
        phases.completeness_percentage_for(:prototypes).should eq 70
      end
    end

    def many_days_ago
      100.years.ago
    end

    def many_days_from_now
      100.years.from_now
    end
  end

  describe 'current phase' do
    it 'when ideas is current' do
      dates = Dates.new(1.year.ago, 1.day.from_now, 2.days.from_now, 3.days.from_now)
      Phases.is_current?(:ideas, dates).should be
      Phases.is_current?(:ideas_selection, dates).should_not be
      Phases.is_current?(:prototypes, dates).should_not be
    end

    it 'when ideas selection is current' do
      dates = Dates.new(1.year.ago, 1.day.ago, 2.days.from_now, 3.days.from_now)
      Phases.is_current?(:ideas, dates).should_not be
      Phases.is_current?(:ideas_selection, dates).should be
      Phases.is_current?(:prototypes, dates).should_not be
    end

    it 'when prototypes is current' do
      dates = Dates.new(1.year.ago, 3.days.ago, 2.days.ago, 3.days.from_now)
      Phases.is_current?(:ideas, dates).should_not be
      Phases.is_current?(:ideas_selection, dates).should_not be
      Phases.is_current?(:prototypes, dates).should be
    end
  end
end
