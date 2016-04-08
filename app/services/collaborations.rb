module Collaborations
  def self.create_after_registration(member)
    return if challenges_store.count != 1

    create_without_email(member, last_challenge).tap do |record|
      if able_to_send_welcome_message?(record, member, last_challenge)
        mailer.welcome(member.email, record).deliver
      end
    end
  end

  def self.create_without_email(member, challenge)
    return if exists_collaboration?(member, challenge)
    return unless phases.current?(:ideas, challenge)
    store.create(member_id: member.id, challenge_id: challenge.id)
  end

  def self.config=(config)
    @@config = config
  end

  private

  def self.able_to_send_welcome_message?(record, member, challenge)
    record && member.email.present? && challenge.welcome_mail.present?
  end

  def self.exists_collaboration?(member, challenge)
    store.find_by_member_id_and_challenge_id(member.id, challenge.id)
  end

  def self.config
    @@config ||= {
      store: ::Collaboration,
      mailer: ChallengeMailer,
      challenges_store: ::Challenge,
      phases: Phases
    }
  end

  def self.store
    config.fetch(:store)
  end

  def self.challenges_store
    config.fetch(:challenges_store)
  end

  def self.mailer
    config.fetch(:mailer)
  end

  def self.phases
    config.fetch(:phases)
  end

  def self.last_challenge
    challenges_store.last_created
  end
end
