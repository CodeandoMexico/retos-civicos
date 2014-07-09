class EntriesMailer < ActionMailer::Base
  default from: ENV['MAILER_DEFAULT_FROM']

  def entry_accepted(entry)
    @entry = entry
    @challenge = entry.challenge
    @contact_email = ENV['MAILER_DEFAULT_FROM']

    mail to: entry.member.email
  end
end
