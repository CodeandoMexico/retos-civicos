require 'spec_helper'

feature 'Brigades' do
  let!(:signedin) do
    user = new_user
    sign_in_user(user)
  end
  fixtures :locations

  scenario 'Creating a Brigade as a logged in user' do
    Capybara.using_driver :selenium do
      user = new_user
      sign_in_user(user)
      visit new_brigade_en_path
      expect(page).to have_content I18n.t('brigades.new.header')
      expect(page).to have_content I18n.t('brigades.new.submit')
      fill_in 'location-query', with: 'tequila'
      page.should have_selector('.location-list-option')
      first('.location-list-option').click
      fill_in 'brigade_description', with: 'Bienvenido a la brigada de Monterrey!'
      click_on I18n.t('brigades.new.submit')
      expect(page).to have_content 'Monterrey'
    end
  end
end
