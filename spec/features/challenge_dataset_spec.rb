require 'spec_helper'

feature "Challenges Datasets" do
  attr_reader :organization, :challenge

  before do
    @organization = create :organization
    @challenge = create :challenge, organization: organization
    sign_in_organization_admin(organization.admin)
  end

  scenario "Add and view dataset of a challenge", js: true do
    visit edit_organization_challenge_path(organization, challenge)

    #agregar un dataset
    fill_in 'token-input-challenge_dataset_id', with: 'Banco mundial'
    wait_for_ajax
    find(".token-input-selected-dropdown-item").click
    click_button "Publicar"

    #ver un dataset
    within '.tabs' do
      page.should have_content '1 Dataset'
    end
    click_link '1 Dataset'
    within '#datasetsTTab' do
      find(".dataset-teaser")
    end
  end
end
