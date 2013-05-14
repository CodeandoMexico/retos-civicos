task data_port: ['orgs:create_orgs_and_link_to_challenges', 'users:create_members_and_migrate_users']

desc "Create members for existing users and port their collaborations for Challenges"
namespace :users do

  task create_members_and_migrate_users: :environment do
    # Create members
    User.where(userable_type: nil).each do |user|
      user.create_role 
    end

    # Relate collaborations to members
    Collaboration.all.each do |c|
      if c.user.userable == "Member"
        c.member = c.user.userable 
        c.save
      end
    end
  end

end

desc "Create Organizations and Port challenges ownership to Organizations"
namespace :orgs do

  task create_orgs_and_link_to_challenges: :environment do
    creators = Challenge.pluck(:creator_id)
    users = User.find creators

    users.each do |user|
      user.create_role({ organization: true })
    end

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
