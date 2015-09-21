task migrate_challenges: :environment do
  migrate_challenges(Challenge.where(starts_on: nil))
end

def migrate_challenges(challenges)
  challenges.each { |challenge| migrate(:challenge, challenge) }
end

def migrate(resource, challenge)
  if resource == :challenge
      challenge.starts_on = challenge.created_at
      challenge.ideas_phase_due_on = challenge.created_at
      challenge.ideas_selection_phase_due_on = challenge.created_at
      challenge.prototypes_phase_due_on = challenge.created_at
      challenge.finish_on = challenge.updated_at
      challenge.save(validate: false)
  end
end
