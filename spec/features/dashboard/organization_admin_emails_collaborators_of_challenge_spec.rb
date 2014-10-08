require 'spec_helper'

describe 'Organization admin emails collaborators of a challenge' do

  let(:user) { create :user, name: 'Admin Name' }
  let(:organization) { create :organization }
  let(:organization_admin) { create :user, userable: organization }
  let(:challenge) { create :challenge, :open, organization: organization }

  it 'only to selected finalists' do
    member_one = create_a_member_with_a_collaboration('John Deliver').member
    member_two = create_a_member_with_a_collaboration('Mike Deliver').member
    create :entry, :accepted, challenge: challenge, member: member_one
    create :entry, :accepted, challenge: challenge, member: member_two

    sign_in_organization_admin(organization_admin)
    click_link 'Participantes'
    click_link 'Enviar email a finalistas'

    uncheck "members_#{member_one.id}"

    fill_in 'email[subject]', with: 'Titulo del correo'
    fill_in 'email[body]', with: 'Contenido del correo'

    expect { click_on 'Enviar' }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'only to registered users' do
    create_a_member_with_a_collaboration('John Deliver')
    create_a_member_with_a_collaboration('Mike Deliver')
    create_a_member_without_a_collaboration

    sign_in_organization_admin(organization_admin)
    click_link 'Participantes'
    click_link 'Enviar email a todos'

    fill_in 'email[subject]', with: 'Titulo del correo'
    fill_in 'email[body]', with: 'Contenido del correo'

    expect { click_on 'Enviar' }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  def create_a_member_with_a_collaboration(name)
    tmp_user = create :user, name: name
    tmp_member = create :member, user: tmp_user
    create :collaboration, member: tmp_member, challenge: challenge
  end

  def create_a_member_without_a_collaboration
    another_user = create :user, name: 'Pedro NoDeliver'
    create :member, user: another_user
  end
end
