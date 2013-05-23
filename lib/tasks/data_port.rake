task data_port: ['orgs:create_orgs_and_link_to_challenges', 'users:create_members_and_migrate_users']

desc "Create members for existing users and port their collaborations for Challenges"
namespace :users do

  task create_members_and_migrate_users: :environment do
    # Create members
    puts "Creating members..."
    User.where(userable_type: nil).each do |user|
      user.create_role 
    end

    # Relate collaborations to members
    puts "Relating collaborations to members..."
    Collaboration.all.each do |c|
      if c.user.member?
        c.member = c.user.userable 
        c.save
      end
    end

    puts "Cleaning up members with user equals nil..."
    Member.all.each { |m| m.destroy if m.user.nil? }
  end

end

desc "Create Organizations and Port challenges ownership to Organizations"
namespace :orgs do

  task create_orgs_and_link_to_challenges: :environment do
    creators = Challenge.pluck(:creator_id)
    users = User.find creators

    puts "Creating organizations..."
    users.each do |user|
      user.create_role({ organization: true })
    end

    puts "Mapping organization challenges..."
    users.each do |user|
      organization = Organization.find user.userable_id
      challenges = Challenge.where(creator_id: user.id)
      challenges.each do |c| 
        c.organization = organization
        c.save
      end
    end
  end
end
