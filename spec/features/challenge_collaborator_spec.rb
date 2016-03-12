require 'spec_helper'
require 'carrierwave/test/matchers'

feature 'Ajax load collaborators' do
  let!(:organization) { new_organization }
  let!(:challenge) { FactoryGirl.create(:challenge, organization: organization) }
  scenario 'Find all collaborators in collaborator tab', js: true do
    pending

    double(Member.paginates_per(1))

    collaborators = []
    2.times do
      collaborators.push(FactoryGirl.create(:collaboration, challenge: challenge, member: new_member))
    end
    visit challenge_path(collaborators.first.challenge_id)

    within '#collaborators_tab_pane' do
      page.should have_css("img[alt='#{collaborators[0].member.name}']")
      page.should_not have_css("img[alt='#{collaborators[1].member.name}']")
      click_link 'Mostrar más'
      page.should have_css("img[alt='#{collaborators[1].member.name}']")
      page.should_not have_content('Mostrar más')
    end
  end
end
