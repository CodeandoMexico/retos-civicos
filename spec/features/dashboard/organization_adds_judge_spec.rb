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

  scenario 'user clicks on a challenge and sends invitation to a judge' do
    click_link 'Jurado'
    invite_new_judge
  end

  def invite_new_judge
    click_on 'Agregar juez'
    fill_in 'judge_email', with: 'nuevo@juez.com'
    click_on 'Agregar'
  end
end
