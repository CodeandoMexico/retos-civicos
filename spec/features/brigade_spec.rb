require 'spec_helper'

feature 'Brigades' do
  let!(:signedin) do
    user = new_user
    sign_in_user(user)
  end
  
  scenario 'Creating a Brigade as a logged in user' do
    visit new_brigade_en_path
    expect(page).to have_content I18n.t('brigades.new.header')
    expect(page).to have_content I18n.t('brigades.new.submit')
    fill_in 'brigade_zip_code', with: '66603'
    fill_in 'brigade_description', with: 'Bienvenido a la brigada de Monterrey!'
    click_on I18n.t('brigades.new.submit')
    expect(page).to have_content 'Monterrey'
  end
  
  scenario 'Follow a Brigade as a logged in user' do
    visit brigade_path(1)
    click_on "Seguir" #Follow
    expect(page).to have_content 'Estas siguiendo esta brigada ahora'
    visit user_path(new_user.id)
    expect(page).to have_content 'Monterrey'
  end
  
  scenario 'Unfollow a followed Brigade as a logged in user' do
    visit brigade_path(1)
    click_on "Seguir"
    visit user_path(new_user.id)
    click_on "Dejar de seguir" #Unfollow
    expect(page).to have_content 'No estas siguiendo Monterrey ahora'
  end
  
  scenario 'Make sure cannot refollow an already followed Brigade' do
    visit brigade_path(1)
    click_on "Seguir" #Follow
    visit brigade_path(1)
    expect(page).to have_content "Dejar de seguir"
    expect(page).not_to have_content "Seguir"
  end
end
