task data_port: ['users:create_members_and_migrate_users']

desc "Create members for existing users and port their collaborations for Challenges"
namespace :users do

  task create_members_and_migrate_users: :environment do
    # Create members
    User.all.each do |user|
      user.create_role
    end

    # Relate collaborations to members
    Collaboration.all.each do |c|
      c.member = c.user.userable
      c.save
    end
  end

end
