require 'active_support/all'
require_relative '../../app/services/phases'
require_relative '../../app/services/phases/null_phase'
require_relative '../../app/services/phases/phase'
require_relative '../../app/services/phases/phases_for_dates'
require_relative '../../app/services/phases/timeline'

describe Phases do
  Dates = Struct.new(
    :starts_on,
    :ideas_phase_due_on,
    :ideas_selection_phase_due_on,
    :prototypes_phase_due_on)

  describe 'phases for dates' do
    attr_reader :phases

    before do
      configure_i18n
      dates = Dates.new(1.year.ago, 1.day.from_now, 2.days.from_now, 3.days.from_now)
      @phases = Phases.for_dates(dates)
    end

    it 'has a phase of ideas' do
      phases.fetch(:ideas).should be
    end

    it 'has a phase of ideas selection' do
      phases.fetch(:ideas_selection).should be
    end

    it 'has a phase of prototypes' do
      phases.fetch(:prototypes).should be
    end

    it 'has a phase of prototypes selection' do
      phases.fetch(:prototypes_selection).should be
    end
  end

  describe 'phase completeness percentage' do
    [
      { current: :ideas, phases: { ideas: 60, ideas_selection: 0, prototypes: 0, prototypes_selection: 0 } },
      { current: :ideas_selection, phases: { ideas: 100, ideas_selection: 30, prototypes: 0, prototypes_selection: 0 } },
      { current: :prototypes, phases: { ideas: 100, ideas_selection: 100, prototypes: 70, prototypes_selection: 0 } }
    ].each do |example|
      current_phase = example.fetch(:current)
      percentage = example.fetch(:phases).fetch(current_phase)

      it "when #{current_phase} phase is at #{percentage}%" do
        example.fetch(:phases).each do|phase, percentage|
          dates = dates_for_phase(current_phase)
          Phases.completeness_percentage_for(phase, dates).should eq percentage
        end
      end
    end
  end

  describe 'current phase' do
    phases = [:ideas, :ideas_selection, :prototypes, :prototypes_selection]
    phases.each do |current_phase|
      it "when #{current_phase} is current" do
        dates = dates_for_phase(current_phase)
        not_current_phases = phases.reject { |phase| phase == current_phase }

        Phases.is_current?(current_phase, dates).should be
        not_current_phases.each { |phase| Phases.is_current?(phase, dates).should_not be }
      end
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

  def many_days_ago
    100.years.ago
  end

  def many_days_from_now
    100.years.from_now
  end

  def dates_for_phase(phase)
    {
      ideas: Dates.new(6.days.ago, 4.days.from_now, many_days_from_now, many_days_from_now),
      ideas_selection: Dates.new(many_days_ago, 3.days.ago, 7.days.from_now, many_days_from_now),
      prototypes: Dates.new(many_days_ago, many_days_ago, 7.days.ago, 3.days.from_now),
      prototypes_selection: Dates.new(1.year.ago, 4.days.ago, 3.days.ago, 2.days.ago)
    }.fetch(phase)
  end

  def configure_i18n
    I18n.default_locale = :es
    I18n.load_path << File.expand_path('../../config/locales/es.yml', File.dirname(__FILE__))
    I18n.load_path << File.expand_path('../../config/locales/phases.es.yml', File.dirname(__FILE__))
  end
end
