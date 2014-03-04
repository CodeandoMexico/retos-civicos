require 'spec_helper'

feature "Challenges Datasets" do

  let!(:organization) { new_organization }
  let!(:challenge) { FactoryGirl.create(:challenge, organization: organization) }


  before do
    sign_in_user(organization.user, password: 'password')
  end

  scenario "Add and view dataset of a challenge", js: true do
    visit edit_organization_challenge_path(organization, challenge)

    #agregar un dataset
    fill_in 'token-input-challenge_dataset_id', with: 'Banco mundial'
    find(".token-input-selected-dropdown-item").click
    click_button "Publicar"

    #ver un dataset
    within '.tabs' do
      page.should have_content '1 Dataset'
    end
    click_link '1 Dataset'
    within '#datasetsTTab' do
      page.should have_link 'Banco Mundial', 'http://datamx.io/dataset/banco-mundial'
      page.should have_content 'Migración neta: La migración neta es, el total neto de personas que migraron durante el período:...'
    end

  end

end
