require 'spec_helper'

feature 'User update his information' do
  attr_reader :user, :member

  before do
    other_challenge = create :challenge

    @user = create :user
    @member = user.userable
    @challenge = create :challenge
    sign_in_user(user, password: 'password')
  end

  scenario 'after sign up, and fill with correct information' do
    fill_in 'member_name', with: 'Raúl Jiménez'
    fill_in 'member_bio', with: 'I live in Monterrey, N.L., Mexico'
    fill_in 'member_github_url', with: 'https://github.com/acrogenesis'
    fill_in 'member_twitter_url', with: 'https://twitter.com/acrogenesis'
    fill_in 'member_facebook_url', with: 'https://facebook.com/acrogenesis'
    attach_file 'member_avatar', cmx_logo_path

    click_on 'Actualizar'
    expect(current_path).to eq member_path(@member)

    click_on 'Raúl Jiménez'
    click_on 'Perfil'
    expect(page).to have_content 'Raúl Jiménez'
    expect(page).to have_content 'I live in Monterrey, N.L., Mexico'
  end

  scenario 'after sign up, and fill with incorrect information' do
    fill_in 'member_name', with: 'Raúl Jiménez'
    fill_in 'member_bio', with: text_of_length(300)

    click_on 'Actualizar'
    expect(current_path).to eq member_path(member)
  end

  def charter_path
    Rails.root.join('spec/fixtures/dummy.pdf')
  end

  def cmx_logo_path
    Rails.root.join('app/assets/images/logocmx@2x.png')
  end

  def text_of_length(length)
    'a' * length
  end
end
