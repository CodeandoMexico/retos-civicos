require 'spec_helper'

feature 'Admin logs into jury section' do
  attr_reader :challenge_name

  before do
    @challenge_name = 'Primer reto'

    organization = create :organization
    organization_admin = create :user, userable: organization
    challenge = create :challenge, title: @challenge_name, organization: organization

    sign_in_organization_admin(organization_admin)
  end

  scenario 'user clicks on a challenge and sends invitation to a judge with invalid information' do
    click_link 'Jurado'
    invite_new_judge('Juez 1', 'correo_incorrecto@.com')
    expect(page).to have_content 'El usuario no pudo guardarse'
  end

  scenario 'user clicks on a challenge and sends invitation to a judge with invalid information' do
    click_link 'Jurado'
    invite_new_judge('Juez 1', 'correo@valido.com')
    expect(page).to have_content 'El juez ha sido invitado satisfactoriamente'
  end

  def invite_new_judge(name, email)
    click_on 'Agregar juez'
    fill_in 'user_name', with: name
    fill_in 'user_email', with: email
    click_on 'Agregar jurado'
  end
end
