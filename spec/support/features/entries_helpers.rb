require 'rails/commands/server'
module EntriesHelpers
  def entries_with_different_members(number_of_entries, challenge)
    entries = []
    number_of_entries.times do |idx|
      entries << create(:entry,
                        challenge: challenge,
                        member: new_member,
                        name: "Propuesta #{idx}",
                        description: "This is a description #{idx}",
                        idea_url: 'slideshare.com/loqusea',
                        technologies: %w(PHP Rust),
                        created_at: Time.zone.local(2014, 4, 25, 10, 52, 24)
                       )
    end
    entries
  end

  def invalid_entries_in_challenge(number_of_entries, challenge)
    entries = []
    number_of_entries.times do |idx|
      entries << create(:entry,
                        challenge: challenge,
                        member: new_member,
                        name: "Inválida #{idx}",
                        description: "This is a description #{idx}",
                        idea_url: 'slideshare.com/loqusea',
                        technologies: %w(PHP Rust),
                        created_at: Time.zone.local(2014, 4, 25, 10, 52, 24),
                        is_valid: false
                       )
    end
    entries
  end
end
