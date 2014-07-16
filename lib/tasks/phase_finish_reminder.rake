task phase_finish_reminder: :environment do
  PhaseFinishReminder.notify_collaborators_of_challenges(Challenge.active, ChallengeMailer)
end
