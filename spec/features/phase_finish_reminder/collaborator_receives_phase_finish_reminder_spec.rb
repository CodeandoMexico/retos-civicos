require 'spec_helper'

feature 'Collaborator receives phase finish reminder' do
  scenario 'for ideas phase' do
    pending
    member = create :member
    challenge = create :challenge, title: 'Reto Alerta', ideas_phase_due_on: 7.days.from_now
    collaboration = create :collaboration, member: member, challenge: challenge

    reset_email
    send_phase_finish_reminders!
    member_should_receive_phase_finish_reminder(member)
  end

  scenario 'just if the user accepts to receive phase finish reminders' do
    member = create :member, phase_finish_reminder_setting: false
    challenge = create :challenge, ideas_phase_due_on: 7.days.from_now
    collaboration = create :collaboration, member: member, challenge: challenge

    reset_email
    send_phase_finish_reminders!
    member_should_not_receive_phase_finish_reminder
  end

  scenario 'but just at the right time' do
    pending
    member = create :member
    challenge = create :challenge, ideas_phase_due_on: 8.days.from_now
    collaboration = create :collaboration, member: member, challenge: challenge

    reset_email
    send_phase_finish_reminders!
    member_should_not_receive_phase_finish_reminder
  end

  def send_phase_finish_reminders!
    PhaseFinishReminder.notify_collaborators_of_challenges(Challenge.active, ChallengeMailer)
  end

  def member_should_not_receive_phase_finish_reminder
    ActionMailer::Base.deliveries.should be_empty
  end

  def member_should_receive_phase_finish_reminder(member)
    mail = ActionMailer::Base.deliveries.find { |mail| mail.to.include? member.email }
    mail.subject.should eq 'Reto Alerta - Quedan 7 días para enviar tu idea'
    mail.body.to_s.should have_content 'Quedan 7 días para enviar tu propuesta en la etapa de ideas'
  end
end
