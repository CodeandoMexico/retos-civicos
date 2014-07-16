require_relative 'phases'

module PhaseFinishReminder
  def self.notify_collaborators_of_challenges(challenges, notifier)
    challenges = PhaseFinishReminder::Challenge.build_collection(challenges)
    challenges.each do |challenge|
      challenge.send_phase_finish_reminder_if_needed(notifier)
    end
  end

  def self.mail_subject(challenge)
    challenge = PhaseFinishReminder::Challenge.new(challenge)
    challenge.mail_subject
  end

  def self.mail_body(challenge)
    challenge = PhaseFinishReminder::Challenge.new(challenge)
    challenge.mail_body
  end

  private

  def self.t(key, options = {})
    I18n.t("phase_finish_reminder.#{key}", options)
  end

  class Challenge
    def initialize(record, phases = Phases, translator = PhaseFinishReminder)
      @record = record
      @phases = phases
      @translator = translator
    end

    def self.build_collection(records)
      records.map { |record| new(record) }
    end

    def mail_subject
      return '' unless notifiable?

      translator.t(
        'mail_subject',
        title: record.title,
        days_left: days_left_for_current_phase,
        thing_to_send: thing_to_send)
    end

    def mail_body
      return {} unless notifiable?

      { days_left: days_left_for_current_phase,
        phase: phases.current(record).downcase,
        challenge_id: id }
    end

    def send_phase_finish_reminder_if_needed(notifier)
      return unless notifiable?

      record.collaborators_emails.each do |collaborator_email|
        notifier.phase_finish_reminder(collaborator_email, id).deliver
      end
    end

    private

    def id
      record.id
    end

    def notifiable?
      (is_current_phase?(:ideas) || is_current_phase?(:prototypes)) &&
        days_left_for_current_phase <= 7
    end

    def thing_to_send
      translator.t("thing_to_send.#{phases.current_phase_id(record)}")
    end

    def is_current_phase?(phase)
      phases.is_current?(phase, record)
    end

    def days_left_for_current_phase
      phases.days_left_for_current_phase(record)
    end

    attr_reader :record, :phases, :translator
  end
end
