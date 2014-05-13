require 'spec_helper'
require 'carrierwave/test/matchers'

feature "Submit an app" do
  include CarrierWave::Test::Matchers

  let!(:member) { new_member }
  let!(:organization) { new_organization }
  let!(:challenge) { create :challenge, organization: organization }

  background do
    sign_in_user(member.user, password: 'password')
    create :collaboration, member: member, challenge: challenge
  end

  scenario "Create and submit app" do
    visit new_challenge_entry_path(challenge)

    within '#new_entry' do
      fill_in 'entry_name', with: 'App de Prueba'
      fill_in 'entry_description', with: 'Spec de subir una app'
      fill_in 'entry_github_url', with: 'https://github.com/CodeandoMexico/aquila'
      fill_in 'entry_live_demo_url', with: 'http://codeandomexico.org'
      attach_file 'entry_entry_logo', image_url_for('happy-face')
      attach_file 'entry_image', image_url_for('happy-face')
      fill_in 'entry_team_members', with: 'yo, y los demas'
      click_button 'Enviar proyecto'
    end

    within '#pitch' do
      page.should have_content 'App de Prueba'
      page.should have_content 'Spec de subir una app'
      page.should have_content 'https://github.com/CodeandoMexico/aquila'
      page.should have_content 'http://codeandomexico.org'
      page.should have_content 'yo, y los demas'
    end

    click_link "Ir al reto - #{challenge.title}"

    within '.challenge-tabs' do
      page.should have_content '0 App'
    end

    clean_images_and_created_folders
  end

  private

  def image_url_for(name)
    "#{Rails.root}/spec/images/#{name}.jpg"
  end

  def clean_images_and_created_folders
    FileUtils.rm_rf(Dir["#{Rails.root}/public/entries_logo/entry/entry_logo/1"])
  end
end
