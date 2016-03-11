require 'spec_helper'

feature "Brigades" do
  scenario "Creating a Brigade as a logged in user" do
    user = new_user
    sign_in_user(user)
    visit new_brigade_en_path
    expect(page).to have_content I18n.t('brigades.new.header')
    expect(page).to have_content I18n.t('brigades.new.submit')
    fill_in "brigade_zip_code", with: "66603"
    fill_in "brigade_description", with: "Bienvenido a la brigada de Monterrey!"
    click_on I18n.t('brigades.new.submit')
    expect(page).to have_content "Monterrey"
  end
end
