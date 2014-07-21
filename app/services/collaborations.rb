module Collaborations
  def self.create_after_registration(member)
    return if challenges_store.count != 1
    return if exists_collaboration?(member, last_challenge)

    store.create(member_id: member.id, challenge_id: last_challenge.id).tap do |record|
      if member.email.present? && last_challenge.welcome_mail.present?
        mailer.welcome(member.email, record).deliver
      end
    end
  end

  def self.create_without_email(member, challenge)
    return if exists_collaboration?(member, challenge)
    store.create(member_id: member.id, challenge_id: challenge.id)
  end

  def self.config=(config)
    @@config = config
  end

  private

  def self.exists_collaboration?(member, challenge)
    store.find_by_member_id_and_challenge_id(member.id, challenge.id)
  end

  def self.config
    @@config ||= {
      store: ::Collaboration,
      mailer: ChallengeMailer,
      challenges_store: ::Challenge
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

  def self.last_challenge
    challenges_store.last_created
  end
end
