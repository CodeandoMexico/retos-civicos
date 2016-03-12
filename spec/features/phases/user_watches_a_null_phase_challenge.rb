require 'spec_helper'

feature 'When a challenge has a null phase' do
  attr_reader :finished_challenge, :unstarted_challenge, :starts_today_challenge

  before do
    @finished_challenge = create :challenge,
                                 ideas_phase_due_on: 2.weeks.ago,
                                 ideas_selection_phase_due_on: 1.week.ago,
                                 prototypes_phase_due_on: 1.week.ago,
                                 finish_on: 2.days.ago

    @unstarted_challenge = create :challenge,
                                  starts_on: 1.day.from_now,
                                  ideas_phase_due_on: 2.weeks.from_now,
                                  ideas_selection_phase_due_on: 1.week.from_now,
                                  prototypes_phase_due_on: 1.week.from_now,
                                  finish_on: 2.days.from_now

    @starts_today_challenge = create :challenge,
                                     starts_on: Date.current,
                                     ideas_phase_due_on: 2.weeks.from_now,
                                     ideas_selection_phase_due_on: 1.week.from_now,
                                     prototypes_phase_due_on: 1.week.from_now,
                                     finish_on: 2.days.from_now
  end

  scenario 'and is finished it should say it has concluded' do
    visit challenge_path(finished_challenge)
    page.should have_content 'Concluido'
  end

  scenario 'and is finished it should say it has concluded' do
    visit challenge_path(unstarted_challenge)
    page.should have_content 'No ha comenzado'
  end

  scenario 'and has started it should say it has started' do
    visit challenge_path(starts_today_challenge)
    save_and_open_page
    page.should have_content 'Ideas'
  end
end
