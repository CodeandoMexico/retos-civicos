task faker: :environment do
  # organizations
  organizations = (1..10).map do
    org_name = Faker::Company.name
    o = Organization.new slug: Faker::Internet.slug(org_name, '-')
    u = User.new(name: org_name, email: fetch_email(:organization, org_name), password: 'password')
    u.skip_confirmation!
    u.userable = o
    u.save
    u.userable
  end

  # Members
  members = (1..100).map do
    member_name = Faker::Name.name
    u = User.new name: member_name, email: fetch_email(:member, member_name), password: 'password'
    u.userable = Member.create
    u.skip_confirmation!
    u.save
    u.userable
  end

  # challenges
  challenges = (1..20).map do
    starts_on = Faker::Number.between(10, 40).days.ago
    ideas_phase_due_on = starts_on + Faker::Number.between(10, 40).days
    ideas_selection_phase_due_on = ideas_phase_due_on + Faker::Number.between(10, 40).days
    prototypes_phase_due_on = ideas_selection_phase_due_on + Faker::Number.between(10, 40).days
    finish_on = prototypes_phase_due_on + Faker::Number.between(10, 40).days

    c = Challenge.new(
      title: Faker::Book.title,
      description: Faker::Lorem.paragraphs,
      status: 'open',
      pitch: Faker::Lorem.sentence,
      about: Faker::Hacker.say_something_smart,
      prize: 'Contrato por 300K MXN',
      starts_on: starts_on,
      ideas_phase_due_on: ideas_phase_due_on,
      ideas_selection_phase_due_on: ideas_selection_phase_due_on,
      prototypes_phase_due_on: prototypes_phase_due_on,
      finish_on: finish_on
    )

    c.organization = organizations.sample
    c.save
    c
  end
end

def fetch_email(kind, prefix)
  case kind
  when :organization
    Faker::Internet.safe_email(prefix)
  when :member
    Faker::Internet.free_email(prefix)
  end
end
