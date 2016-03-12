task add_collaborations_to_first_challenge: :environment do
  challenge = Challenge.last

  puts 'Add collaborations to first challenge'
  Member.includes(:user).find_each do |member|
    print '.' if Collaborations.create_without_email(member, challenge)
  end
  puts ''
end
