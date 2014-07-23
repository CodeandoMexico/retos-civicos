require 'spec_helper'

describe 'Organization admin emails collaborators of a challenge' do

  let(:user) { create :user, name: 'Admin Name' }
  let(:organization) { create :organization }
  let(:organization_admin) { create :user, userable: organization }
  let(:challenge) { create :challenge, :open, organization: organization }


  it 'only to registered users' do
    create_a_member_with_a_collaboration
    create_a_member_without_a_collaboration
    sign_in_organization_admin(organization_admin)
    click_link 'Participantes'
    click_link 'Enviar email a todos'

    fill_in 'email[subject]', with: 'Titulo del correo'
    fill_in 'email[body]', with: 'Contenido del correo'
    # save_and_open_page

    # puts ActionMailer::Base.deliveries.count
    expect { click_on 'Enviar' }.to change { ActionMailer::Base.deliveries.count }.by(100)

  end

  def create_a_member_with_a_collaboration
    tmp_user = create :user, name: 'Juan Deliver'
    tmp_member = create :member, user: tmp_user
    create :collaboration, member: tmp_member, challenge: challenge
  end

  def create_a_member_without_a_collaboration
    another_user = create :user, name: 'Pedro NoDeliver'
    create :member, user: another_user
  end
end
