task update_first_challenge_phases_dates: :environment do
  challenge = Challenge.first
  challenge.starts_on = Date.new(2014,6,25)
  challenge.ideas_phase_due_on = Date.new(2014,7,22)
  challenge.ideas_selection_phase_due_on = Date.new(2014,8,11)
  challenge.prototypes_phase_due_on = Date.new(2014,9,11)
  challenge.save
end
