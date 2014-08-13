require 'spec_helper'

feature "Challenges page" do

  let!(:starts_tomorrow_ch) { FactoryGirl.create(:challenge, starts_on: 1.day.from_now) }
  let!(:starts_today_ch) { FactoryGirl.create(:challenge, starts_on: Date.current) }
  let!(:active_ch) { FactoryGirl.create(:challenge) }
  let!(:working_on_ch) { FactoryGirl.create(:challenge, status: 'working_on') }
  let!(:finished_ch) { FactoryGirl.create(:challenge, status: 'finished') }
  let!(:cancelled_ch) { FactoryGirl.create(:challenge, status: 'cancelled') }
  let!(:private_ch) { FactoryGirl.create(:challenge, status: 'private') }

  before do
    # double(Challenge.paginates_per(2))
    # visit challenges_path
  end

  scenario "Default filter is by date" do
    # Default aquila behavior
    pending
    page.should have_content(cancelled_ch.title)
    page.should_not have_content(active_ch.title)
  end

  scenario "Active filter shows only active challenges" do
    # Default aquila behavior
    pending
    click_link("Activos")
    page.should have_content(active_ch.title)
    page.should_not have_content(finished_ch.title)
  end

  scenario "Inactive filter shows only the finished challenges" do
    # Default aquila behavior
    pending
    click_link("Concluidos")
    page.should have_content(finished_ch.title)
    page.should_not have_content(active_ch.title)
  end

  scenario "Most popular filter challenges sorted by most collaborators" do
    # Default aquila behavior
    pending
    FactoryGirl.create_list(:collaboration, 3, challenge: finished_ch)
    FactoryGirl.create_list(:collaboration, 1, challenge: active_ch)
    click_link("Más populares")
    page.should have_content(finished_ch.title)
    page.should_not have_content(working_on_ch.title)
  end

  scenario "Most recent orders challenges by date" do
    # Default aquila behavior
    pending
    click_link("Más recientes")
    page.should have_content(cancelled_ch.title)
    page.should_not have_content(active_ch.title)
  end

  scenario "There are multiple challenges" do
    visit root_path
    current_path.should eq root_path

    page.should_not have_content starts_tomorrow_ch.title
    page.should have_content starts_today_ch.title
    page.should have_content active_ch.title
    page.should have_content working_on_ch.title
    page.should have_content finished_ch.title
    page.should have_content cancelled_ch.title
  end

  scenario "There's only one challenge" do
    only_one_challenge_left

    visit root_path
    current_path.should eq challenge_path(active_ch)
  end

  def only_one_challenge_left
    starts_today_ch.destroy
    starts_tomorrow_ch.destroy
    working_on_ch.destroy
    finished_ch.destroy
    cancelled_ch.destroy
    private_ch.destroy
  end
end
