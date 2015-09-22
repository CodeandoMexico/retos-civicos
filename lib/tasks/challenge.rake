task migrate_challenges: :environment do
  migrate_challenges(Challenge.where(starts_on: nil))
end

def migrate_challenges(challenges)
  challenges.each { |challenge| migrate(:challenge, challenge) }
end

def migrate(resource, challenge)
  if resource == :challenge
    challenge.update_column(:starts_on, challenge.created_at)
    challenge.update_column(:ideas_phase_due_on, challenge.created_at)
    challenge.update_column(:ideas_selection_phase_due_on, challenge.created_at)
    challenge.update_column(:prototypes_phase_due_on, challenge.created_at)
    challenge.update_column(:finish_on, challenge.created_at)
  end
end
