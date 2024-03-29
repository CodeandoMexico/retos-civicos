require 'spec_helper'

describe EntriesMailer do
  let!(:member) { new_member }
  let!(:organization) { new_organization }
  let!(:challenge) { FactoryBot.create(:challenge, organization: organization) }
  let!(:entry) { FactoryBot.create(:entry, member: member, challenge: challenge) }

  it 'should send the entry_accepted email' do
    reset_email
    mail = EntriesMailer.entry_accepted(entry).deliver
    ActionMailer::Base.deliveries.size.should be 1
    expect(mail.to).to eq [member.email]
    expect(mail.from).to eq(['equipo@codeandomexico.org'])
    expect(mail.subject).to eq('¡Felicidades! Pasaste a la siguiente etapa')
  end
  it 'should send the prototype_confirmation email' do
    reset_email
    mail = EntriesMailer.send_prototype_confirmation(entry).deliver
    ActionMailer::Base.deliveries.size.should be 1
    expect(mail.to).to eq [member.email]
    expect(mail.from).to eq(['equipo@codeandomexico.org'])
    expect(mail.subject).to eq('Recibimos tu prototipo con éxito')
  end
  it 'should send the entry_confirmation_mail_to email' do
    reset_email
    mail = EntriesMailer.send_entry_confirmation_mail_to(challenge, member).deliver
    ActionMailer::Base.deliveries.size.should be 1
    expect(mail.to).to eq [member.email]
    expect(mail.from).to eq(['equipo@codeandomexico.org'])
    expect(mail.subject).to eq('Recibimos tu idea con éxito')
  end
end
