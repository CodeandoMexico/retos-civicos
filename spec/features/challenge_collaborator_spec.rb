require 'spec_helper'
require 'carrierwave/test/matchers'

feature "Ajax load collaborators" do

  let!(:organization) { FactoryGirl.create(:user, userable: Organization.new).userable }
  let!(:challenge) { FactoryGirl.create(:challenge, organization: organization) }

  scenario "Find all collaborators in collaborator tab", js: true do
    first_id = User.last.name.delete("^0-9").to_i
    84.times { FactoryGirl.create(:collaboration, member: FactoryGirl.create(:user, userable: Member.new).userable, challenge: challenge) }
    visit challenge_path(challenge.id)

    within '#collaboratorsTTab' do
      for a in 1..4 do
        within '.collabrow' do
          for i in first_id..a*21 do
            page.should have_css("img[alt='name#{i+1}']")
          end
        end
        unless a==4
          click_link 'Mostrar más'
        end
      end
      page.should_not have_content('Mostrar más')
    end
  end
end
