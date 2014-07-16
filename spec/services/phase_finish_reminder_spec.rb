require_relative '../../app/services/phase_finish_reminder'

describe PhaseFinishReminder do
  class FakeMailer
    def self.deliveries
      @@deliveries ||= []
    end

    def self.clear_deliveries!
      @@deliveries = []
    end

    def phase_finish_reminder(collaborator_email, challenge_id)
      Mail.new(collaborator_email, challenge_id)
    end
  end

  FakeMailer::Mail = Struct.new(:email, :challenge_id) do
    def deliver
      FakeMailer.deliveries << self
    end
  end

  before do
    configure_i18n
    FakeMailer.clear_deliveries!
  end

  describe 'ideas phase' do
    attr_reader :challenge

    before do
      @challenge = build_challenge( starts_on: 3.days.ago, ideas_phase_due_on: 7.days.from_now)
    end

    it 'notifies when the phase is about to finish' do
      PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)

      deliveries = FakeMailer.deliveries
      deliveries.length.should eq 3
      deliveries.should include FakeMailer::Mail.new('uno@example.com', challenge.id)
      deliveries.should include FakeMailer::Mail.new('dos@example.com', challenge.id)
      deliveries.should include FakeMailer::Mail.new('tres@example.com', challenge.id)
    end

    it 'has a subject for the notification' do
      PhaseFinishReminder.mail_subject(challenge).should eq "Reto Alerta - 7 días para enviar tu idea"
    end

    it 'has a body for the notification' do
      PhaseFinishReminder.mail_body(challenge).should eq(
        days_left: 7,
        phase: 'ideas',
        challenge_id: 'challenge-id'
      )
    end
  end

  describe 'ideas selection phase' do
    attr_reader :challenge

    before do
      @challenge = build_challenge(
        starts_on: 3.days.ago,
        ideas_phase_due_on: 2.days.ago,
        ideas_selection_phase_due_on: 4.days.from_now)
    end

    it 'notifies when the current phase of a challenge is about to finish' do
      PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)
      FakeMailer.deliveries.should be_empty
    end

    it 'does not have a subject for the notification' do
      PhaseFinishReminder.mail_subject(challenge).should be_empty
    end

    it 'does not have a body for the notification' do
      PhaseFinishReminder.mail_body(challenge).should be_empty
    end
  end

  describe 'prototypes phase' do
    attr_reader :challenge

    before do
      @challenge = build_challenge(
        starts_on: 3.days.ago,
        ideas_phase_due_on: 2.days.ago,
        ideas_selection_phase_due_on: 1.days.ago,
        prototypes_phase_due_on: 4.days.from_now)
    end

    it 'notifies when phase is about to finish' do
      PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)

      deliveries = FakeMailer.deliveries
      deliveries.length.should eq 3
      deliveries.should include FakeMailer::Mail.new('uno@example.com', challenge.id)
      deliveries.should include FakeMailer::Mail.new('dos@example.com', challenge.id)
      deliveries.should include FakeMailer::Mail.new('tres@example.com', challenge.id)
    end

    it 'has a subject for the notification' do
      PhaseFinishReminder.mail_subject(challenge).should eq "Reto Alerta - 4 días para enviar tu prototipo"
    end

    it 'has a body for the notification' do
      PhaseFinishReminder.mail_body(challenge).should eq(
        days_left: 4,
        phase: 'prototipos',
        challenge_id: 'challenge-id'
      )
    end
  end

  describe 'prototypes selection phase' do
    attr_reader :challenge

    before do
      @challenge = build_challenge(
        starts_on: 4.days.ago,
        ideas_phase_due_on: 3.days.ago,
        ideas_selection_phase_due_on: 2.days.ago,
        prototypes_phase_due_on: 1.days.ago,
        finish_on: 3.days.from_now)
    end

    it 'notifies when the current phase of a challenge is about to finish' do
      PhaseFinishReminder.notify_collaborators_of_challenges([challenge], FakeMailer.new)
      FakeMailer.deliveries.should be_empty
    end

    it 'does not have a subject for the notification' do
      PhaseFinishReminder.mail_subject(challenge).should be_empty
    end

    it 'does not have a body for the notification' do
      PhaseFinishReminder.mail_body(challenge).should be_empty
    end
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
      collaborators_emails: ['uno@example.com', 'dos@example.com', 'tres@example.com']
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
