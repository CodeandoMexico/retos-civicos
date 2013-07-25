class ChallengeMailer < ActionMailer::Base

  helper :application

  default from: "Codeando México <equipo@codeandomexico.org>"

  def welcome(collaboration)
    challenge = collaboration.challenge
    @org = challenge.organization
    @member = collaboration.member

    # Email
    subject = challenge.welcome_mail[:subject]
    @body = challenge.welcome_mail[:body]

    mail to: @member.email, subject: subject
  end

end
