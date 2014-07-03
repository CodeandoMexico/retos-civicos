task add_collaborations_to_first_challenge: :environment do
  challenge = Challenge.last

  puts 'Add collaborations to first challenge'
  Member.includes(:user).find_each do |member|
    if member.user && !member.collaborating_in?(challenge)
      member.collaborations.create(challenge: challenge)
      print '.'
    end
  end
  puts ''
end
