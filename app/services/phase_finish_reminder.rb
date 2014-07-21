require_relative 'phases'

module PhaseFinishReminder
  def self.notify_collaborators_of_challenges(challenges, notifier)
    challenges = PhaseFinishReminder::Challenge.build_collection(challenges)
    challenges.each do |challenge|
      challenge.send_phase_finish_reminder_if_needed(notifier)
    end
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

    def send_phase_finish_reminder_if_needed(notifier)
      return unless notifiable?

      record.collaborators.each do |collaborator|
        if can_notify_collaborator?(collaborator)
          mail_body = mail_body_for(collaborator.id)
          notifier.phase_finish_reminder(collaborator.email, mail_subject, mail_body).deliver
        end
      end
    end

    private

    def can_notify_collaborator?(collaborator)
      collaborator.phase_finish_reminder_setting && collaborator.email.present?
    end

    def mail_subject
      translator.t(
        'mail_subject',
        title: record.title,
        days_left_sentence: days_left_sentence,
        thing_to_send: thing_to_send)
    end

    def mail_body_for(collaborator_id)
      { collaborator_id: collaborator_id,
        days_left_sentence: days_left_sentence,
        phase: phases.current_phase_title(record).downcase,
        challenge_id: id,
        challenge_title: record.title }
    end

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

    def days_left_sentence
      translator.t('days_left_sentence', count: days_left_for_current_phase)
    end

    attr_reader :record, :phases, :translator
  end
end
