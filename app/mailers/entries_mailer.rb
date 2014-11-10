class EntriesMailer < ActionMailer::Base
  default from: ENV['MAILER_DEFAULT_FROM']

  def entry_accepted(entry)
    @entry = entry
    @challenge = entry.challenge
    @contact_email = ENV['MAILER_DEFAULT_FROM']

    mail to: entry.member.email
  end

  def prototype_sent(entry)
    @challenge = entry.challenge
    @contact_email = ENV['MAILER_DEFAULT_FROM']

    mail to: entry.member.email, subject: 'Recibimos tu prototipo con éxito'
  end

  def send_entry_confirmation_mail_to(challenge, member)
    @challenge = challenge
    @timeline = Phases.timeline_from_dates(challenge)
    mail to: member.email, subject: 'Recibimos tu idea con éxito'
  end
end
