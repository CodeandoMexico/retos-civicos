class EntriesMailer < ActionMailer::Base
  default from: ENV['MAILER_DEFAULT_FROM']

  def entry_accepted(entry)
    @entry = entry
    @challenge = entry.challenge
    @contact_email = ENV['MAILER_DEFAULT_FROM']

    mail to: entry.member.email
  end

  def send_prototype_confirmation(entry)
    @challenge = entry.challenge
    @contact_email = ENV['MAILER_DEFAULT_FROM']

    mail to: entry.member.email, subject: 'Recibimos tu prototipo con éxito'
  end

  def send_entry_confirmation_mail_to(challenge, member)
    @challenge = challenge
    @timeline = Phases.timeline_from_dates(challenge)
    mail to: member.email, subject: 'Recibimos tu idea con éxito'
  end

  def entry_has_been_marked_as_invalid(entry)
    @entry = entry
    @challenge = entry.challenge
    @contact_email = ENV['MAILER_DEFAULT_FROM']

    mail to: entry.member.email, subject: "Tu propuesta en el Reto #{@challenge.title}"
  end
end
