class ChallengeMailer < ActionMailer::Base
  helper :application
  default from: ENV['MAILER_DEFAULT_FROM']

  def welcome(email, collaboration)
    challenge = collaboration.challenge
    @org = challenge.organization
    @member = collaboration.member

    # Email
    subject = challenge.welcome_mail[:subject]
    @body = challenge.welcome_mail[:body]

    mail to: email, subject: subject
  end

  def phase_finish_reminder(collaborator_email, mail_subject, mail_body)
    @body = mail_body
    mail to: collaborator_email, subject: mail_subject
  end

  def custom_message_to_all_collaborators(collaborator_email, subject, body)
    @body = body
    mail to: collaborator_email, subject: subject
  end
end
