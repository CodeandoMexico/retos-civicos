require 'active_support/all'
require_relative '../../app/services/phases'

module Phases
  describe 'phases for dates' do
    attr_reader :dates

    Dates = Struct.new(
      :starts_on,
      :ideas_phase_due_on,
      :ideas_selection_phase_due_on,
      :prototypes_phase_due_on)

    before do
      I18n.default_locale = :es
      I18n.load_path << File.expand_path('../../config/locales/es.yml', File.dirname(__FILE__))
      I18n.load_path << File.expand_path('../../config/locales/phases.es.yml', File.dirname(__FILE__))
      @dates = Dates.new(1.year.ago, 1.day.from_now, 2.days.from_now, 3.days.from_now)
    end

    [[:ideas, 'Ideas'],
    [:ideas_selection, 'Selección de ideas'],
    [:prototypes, 'Prototipos'],
    [:prototypes_selection, 'Selección de prototipos']].each do |phase, presentation|
      it "has a presentation for #{phase} phase" do
        phases = Phases.for_dates(dates)
        phases.present(phase).should eq presentation
      end
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
      Phases.current(dates).should eq 'Ideas'
      Phases.is_current?(:ideas, dates).should be
      Phases.is_current?(:ideas_selection, dates).should_not be
      Phases.is_current?(:prototypes, dates).should_not be
    end

    it 'when ideas selection is current' do
      dates = Dates.new(1.year.ago, 1.day.ago, 2.days.from_now, 3.days.from_now)
      Phases.is_current?(:ideas, dates).should_not be
      Phases.is_current?(:ideas_selection, dates).should be
      Phases.current(dates).should eq 'Selección de ideas'
      Phases.is_current?(:prototypes, dates).should_not be
    end

    it 'when prototypes is current' do
      dates = Dates.new(1.year.ago, 3.days.ago, 2.days.ago, 3.days.from_now)
      Phases.is_current?(:ideas, dates).should_not be
      Phases.is_current?(:ideas_selection, dates).should_not be
      Phases.is_current?(:prototypes, dates).should be
      Phases.current(dates).should eq 'Prototipos'
    end

    it 'when prototypes selection is current' do
      dates = Dates.new(1.year.ago, 4.days.ago, 3.days.ago, 2.days.ago)
      Phases.is_current?(:ideas, dates).should_not be
      Phases.is_current?(:ideas_selection, dates).should_not be
      Phases.is_current?(:prototypes, dates).should_not be
      Phases.is_current?(:prototypes_selection, dates).should be
      Phases.current(dates).should eq 'Selección de prototipos'
    end

  end

  describe 'phases bar' do
    attr_reader :bar

    before do
      dates = Dates.new(10.days.ago, 3.days.ago, 7.days.from_now, 10.days.from_now)
      @bar = Phases.timeline_from_dates(dates)
    end

    it 'has a start date' do
      bar.start.date.should eq format_date(10.days.ago)
      bar.start.title.should eq 'Lanzamiento'
    end

    it 'has ideas phase' do
      bar.ideas.completeness.should eq 100
      bar.ideas.title.should eq 'Ideas'
      bar.ideas.due_date.should eq format_date(3.days.ago)
      bar.ideas.due_date_title.should eq 'Cierre Ideas'
    end

    it 'has ideas selection phase' do
      bar.ideas_selection.completeness.should eq 30
      bar.ideas_selection.title.should eq 'Selección de ideas'
      bar.ideas_selection.due_date.should eq format_date(7.days.from_now)
      bar.ideas_selection.due_date_title.should eq 'Anuncio finalistas'
    end

    it 'has prototypes phase' do
      bar.prototypes.completeness.should eq 0
      bar.prototypes.title.should eq 'Prototipos'
      bar.prototypes.due_date.should eq format_date(10.days.from_now)
      bar.prototypes.due_date_title.should eq 'Cierre prototipos'
    end

    def format_date(date)
      I18n.l(date.to_date, format: :phases_bar)
    end
  end
end
