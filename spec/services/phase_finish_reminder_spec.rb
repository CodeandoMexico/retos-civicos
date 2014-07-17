require_relative '../../app/services/phase_finish_reminder'

describe PhaseFinishReminder do
  class FakeMailer
    def self.deliveries
      @@deliveries ||= []
    end

    def self.clear_deliveries!
      @@deliveries = []
    end

    def phase_finish_reminder(collaborator_email, mail_subject, mail_body)
      Mail.new(collaborator_email, mail_subject, mail_body)
    end
  end

  FakeMailer::Mail = Struct.new(:email, :mail_subject, :mail_body) do
    def deliver
      FakeMailer.deliveries << self
    end
  end

  before do
    configure_i18n
    FakeMailer.clear_deliveries!
  end

  it 'notifies when the ideas phase is about to finish' do
    challenge = build_challenge(starts_on: 3.days.ago, ideas_phase_due_on: 7.days.from_now)
    PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)

    deliveries.count.should eq 1
    collaborator_should_receive_email(
      email: 'wants_notification@example.com',
      mail_subject: 'Reto Alerta - Quedan 7 días para enviar tu idea',
      mail_body: {
        collaborator_id: 'with-notification-user-id',
        days_left_sentence: 'Quedan 7 días',
        phase: 'ideas',
        challenge_id: 'challenge-id',
        challenge_title: 'Reto Alerta'
      }
    )
  end

  it 'notifies when the ideas phase has one day left' do
    challenge = build_challenge(starts_on: 3.days.ago, ideas_phase_due_on: 1.days.from_now)
    PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)

    deliveries.count.should eq 1
    collaborator_should_receive_email(
      email: 'wants_notification@example.com',
      mail_subject: 'Reto Alerta - Queda 1 día para enviar tu idea',
      mail_body: {
        collaborator_id: 'with-notification-user-id',
        days_left_sentence: 'Queda 1 día',
        phase: 'ideas',
        challenge_id: 'challenge-id',
        challenge_title: 'Reto Alerta'
      }
    )
  end

  it 'notifies the last day of the ideas phase' do
    challenge = build_challenge(starts_on: 3.days.ago, ideas_phase_due_on: Date.current)
    PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)

    deliveries.count.should eq 1
    collaborator_should_receive_email(
      email: 'wants_notification@example.com',
      mail_subject: 'Reto Alerta - Hoy es el último día para enviar tu idea',
      mail_body: {
        collaborator_id: 'with-notification-user-id',
        days_left_sentence: 'Hoy es el último día',
        phase: 'ideas',
        challenge_id: 'challenge-id',
        challenge_title: 'Reto Alerta'
      }
    )
  end

  it 'does not notify in the ideas selection phase' do
    challenge = build_challenge(
      starts_on: 3.days.ago,
      ideas_phase_due_on: 2.days.ago,
      ideas_selection_phase_due_on: 4.days.from_now
    )

    PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)
    deliveries.should be_empty
  end

  it 'notifies when the prototypes phase is about to finish' do
    challenge = build_challenge(
      starts_on: 3.days.ago,
      ideas_phase_due_on: 2.days.ago,
      ideas_selection_phase_due_on: 1.days.ago,
      prototypes_phase_due_on: 4.days.from_now
    )

    PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)

    deliveries.count.should eq 1
    collaborator_should_receive_email(
      email: 'wants_notification@example.com',
      mail_subject: 'Reto Alerta - Quedan 4 días para enviar tu prototipo',
      mail_body: {
        collaborator_id: 'with-notification-user-id',
        days_left_sentence: 'Quedan 4 días',
        phase: 'prototipos',
        challenge_id: 'challenge-id',
        challenge_title: 'Reto Alerta'
      }
    )
  end

  it 'does not notify in the ideas selection phase' do
    challenge = build_challenge(
      starts_on: 4.days.ago,
      ideas_phase_due_on: 3.days.ago,
      ideas_selection_phase_due_on: 2.days.ago,
      prototypes_phase_due_on: 1.days.ago,
      finish_on: 3.days.from_now
    )

    PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)
    deliveries.should be_empty
  end

  def deliveries
    FakeMailer.deliveries
  end

  def collaborator_should_receive_email(mail_args)
    deliveries.should include FakeMailer::Mail.new(*mail_args.values)
  end

  def build_challenge(options)
    options = {
      id: 'challenge-id',
      title: 'Reto Alerta',
      starts_on: 3.days.ago,
      ideas_phase_due_on: 7.days.from_now,
      ideas_selection_phase_due_on: 15.days.from_now,
      prototypes_phase_due_on: 25.days.from_now,
      finish_on: 35.days.from_now,
      collaborators: [
        OpenStruct.new(
          id: 'with-notification-user-id',
          email: 'wants_notification@example.com',
          phase_finish_reminder_setting: true),
        OpenStruct.new(
          id: 'no-notification-user-id',
          email: 'doesnt_want_notification@example.com',
          phase_finish_reminder_setting: false),
        OpenStruct.new(
          id: 'no-email-user-id',
          email: '',
          phase_finish_reminder_setting: true),
        OpenStruct.new(
          id: 'nil-email-user-id',
          email: nil,
          phase_finish_reminder_setting: true)
      ]
    }.merge(options)

    OpenStruct.new(options)
  end

  def configure_i18n
    I18n.default_locale = :es
    I18n.load_path << File.expand_path('../../config/locales/es.yml', File.dirname(__FILE__))
    I18n.load_path << File.expand_path('../../config/locales/phases.es.yml', File.dirname(__FILE__))
    I18n.load_path << File.expand_path('../../config/locales/phase_finish_reminder.es.yml', File.dirname(__FILE__))
  end
end
