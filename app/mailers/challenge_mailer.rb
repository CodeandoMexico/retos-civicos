class ChallengeMailer < ActionMailer::Base
  helper :application
  default from: ENV['MAILER_DEFAULT_FROM']

  def welcome(collaboration)
    challenge = collaboration.challenge
    @org = challenge.organization
    @member = collaboration.member

    # Email
    subject = challenge.welcome_mail[:subject]
    @body = challenge.welcome_mail[:body]

    mail to: @member.email, subject: subject
  end

  def phase_finish_reminder(collaborator_email, challenge_id)
    challenge = Challenge.find(challenge_id)
    @body = PhaseFinishReminder.mail_body(challenge)

    mail to: collaborator_email, subject: PhaseFinishReminder.mail_subject(challenge)
  end
end
