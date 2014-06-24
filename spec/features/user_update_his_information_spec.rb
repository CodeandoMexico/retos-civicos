require 'spec_helper'

feature 'User update his information' do
  attr_reader :user, :member

  before do
    @user = create :user
    @member = user.userable
    @challenge = create :challenge
    sign_in_user(user, password: 'password')
  end

  scenario 'after sign up, and fill with correct information' do
    fill_in 'member_name', with: 'Raúl Jiménez'
    fill_in 'member_company_name', with: 'Empresa de Raul'
    fill_in 'member_company_rfc', with: 'EDR101005T78'
    attach_file 'member_company_charter', charter_path
    fill_in 'member_bio', with: 'I live in Monterrey, N.L., Mexico'
    attach_file 'member_avatar', cmx_logo_path

    click_on 'Actualizar'
    expect(current_path).to eq challenge_path(@challenge)

    click_on 'Raúl Jiménez'
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
    Rails.root.join('app/assets/images/codeandomexico80.png')
  end

  def text_of_length(length)
    "a" * length
  end
end
