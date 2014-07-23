require 'spec_helper'

describe 'Organization admin emails collaborators of a challenge' do

  let(:user) { create :user, name: 'Admin Name' }
  let(:organization) { create :organization }
  let(:organization_admin) { create :user, userable: organization }
  let(:challenge) { create :challenge, organization: organization }


  it 'only to registered users' do
    sign_in_organization_admin(organization_admin)
    click_link 'Participantes'
    save_and_open_page
    click_link 'Enviar email a todos'

    create_a_member_with_a_collaboration
    create_a_member_without_a_collaboration

    mailer = ChallengeMailer.custom_message_to_all_collaborators(challenge, subject, body)

    expect { mailer.deliver }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  def create_a_member_with_a_collaboration
    user = create :user, name: 'Juan Deliver'
    member = create :member, user: user
    create :collaboration, member: member, challenge: challenge
  end

  def create_a_member_without_a_collaboration
    user = create :user, name: 'Pedro NoDeliver'
    member = create :member, user: user
  end
end
