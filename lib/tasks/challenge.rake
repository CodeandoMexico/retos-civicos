task migrate_challenges: :environment do
  migrate_challenges
end

def migrate_challenges
  Challenge.update_all({
    starts_on: c.created_at,
    ideas_phase_due_on: c.created_at,
    ideas_selection_phase_due_on: c.created_at,
    prototypes_phase_due_on: c.created_at,
    finish_on: c.created_at },
    starts_on: nil
  )
end
