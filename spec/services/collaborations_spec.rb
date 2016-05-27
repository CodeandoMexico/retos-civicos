require_relative '../../app/services/phases'
require_relative '../../app/services/collaborations'

describe Collaborations do
  before do
    FakeChallengeMailer.clear_deliveries!

    Collaborations.config = {
      store: FakeCollaborationsStore.new,
      mailer: FakeChallengeMailer.new,
      challenges_store: FakeChallengeStore.new,
      phases: Phases
    }
  end

  it 'creates collaboration without sending email' do
    member = MemberRecord.new('juanito@example.com')
    challenge = build_challenge(welcome_mail: 'Hola')

    Collaborations.create_without_email(member, challenge)
    collaborations.should include collaboration_for(member, challenge)
    deliveries.should be_empty
  end

  it 'does not create a collaboration if there is one already' do
    member = MemberRecord.new('juanito@example.com')
    challenge = build_challenge(welcome_mail: 'Hola')

    Collaborations.create_without_email(member, challenge)
    Collaborations.create_without_email(member, challenge)

    collaborations.count.should eq 1
  end

  it 'does not create a collaborations on challenge if the ideas phase is not current' do
    member = MemberRecord.new('juanito@example.com')
    challenge = build_challenge(welcome_mail: 'Hola', ideas_phase_due_on: 2.days.ago)

    Collaborations.create_without_email(member, challenge)
    collaborations.should be_empty
    deliveries.should be_empty
  end

  describe 'creates collaboration after registration' do
    attr_reader :member

    before do
      @member = MemberRecord.new
    end

    it 'creates the collaboration if just one challenge exists' do
      Collaborations.challenges_store.push(build_challenge)

      create_after_registration(member)
      collaborations.should include collaboration_for(member, last_challenge)
    end

    it 'does not create a collaboration if more than one challenge exist' do
      Collaborations.challenges_store.push(build_challenge, build_challenge)

      create_after_registration(member)
      collaborations.should be_empty
    end

    it 'does not create a collaboration if there is one already' do
      Collaborations.challenges_store.push(build_challenge)

      create_after_registration(member)
      create_after_registration(member)

      collaborations.count.should eq 1
    end

    it 'does not create a collaborations on challenge if the ideas phase is not current' do
      member = MemberRecord.new('juanito@example.com')
      challenge = build_challenge(ideas_phase_due_on: 2.days.ago)
      Collaborations.challenges_store.push(challenge)

      create_after_registration(member)
      collaborations.should be_empty
      deliveries.should be_empty
    end

    describe 'and sends welcome email' do
      it 'when the member and challenge have email' do
        member = MemberRecord.new('juanito@example.com')
        Collaborations.challenges_store.push(build_challenge(welcome_mail: 'Hola!'))

        collaboration = create_after_registration(member)
        deliveries.should include welcome_email_to('juanito@example.com', collaboration)
      end

      it 'but not when no collaboration is created' do
        member = MemberRecord.new('juanito@example.com')
        Collaborations.challenges_store.push(build_challenge(welcome_mail: 'Hola!'))

        create_after_registration(member)
        collaborations.count.should eq 1
        FakeChallengeMailer.clear_deliveries!

        create_after_registration(member)
        collaborations.count.should eq 1
        deliveries.should be_empty
      end

      it 'but not when the user has no email' do
        member = MemberRecord.new('')
        Collaborations.challenges_store.push(build_challenge(welcome_mail: 'Hola!'))

        create_after_registration(member)
        deliveries.should be_empty
      end

      it 'but not when the challenge has no welcome mail' do
        member = MemberRecord.new('juanito@example.com')
        Collaborations.challenges_store.push(build_challenge(welcome_mail: ''))

        create_after_registration(member)
        deliveries.should be_empty
      end
    end
  end

  class MemberRecord
    attr_reader :id, :email

    def initialize(email = '')
      @id = SecureRandom.uuid
      @email = email
    end
  end

  class ChallengeRecord < OpenStruct
  end

  class FakeCollaborationsStore
    attr_reader :all

    def initialize
      @all = []
    end

    def create(record_attributes)
      all << record_attributes
    end

    def find_by_member_id_and_challenge_id(member_id, challenge_id)
      all.find do |record|
        record == { member_id: member_id, challenge_id: challenge_id }
      end
    end
  end

  class FakeChallengeStore
    attr_reader :all

    def initialize
      @all = []
    end

    def push(*records)
      Array.wrap(records).each { |record| all.push(record) }
    end

    def last_created
      all.last
    end

    def count
      all.count
    end
  end

  class FakeChallengeMailer
    def self.deliveries
      @@deliveries ||= []
    end

    def self.clear_deliveries!
      @@deliveries = []
    end

    def welcome(email, collaboration)
      Mail.new(email, collaboration)
    end
  end

  FakeChallengeMailer::Mail = Struct.new(:email, :collaboration) do
    def deliver
      FakeChallengeMailer.deliveries << self
    end
  end

  def build_challenge(options = {})
    options = {
      id: SecureRandom.uuid,
      starts_on: 3.days.ago,
      ideas_phase_due_on: 7.days.from_now,
      ideas_selection_phase_due_on: 15.days.from_now,
      prototypes_phase_due_on: 25.days.from_now,
      finish_on: 35.days.from_now,
      welcome_mail: ''
    }.merge(options)

    ChallengeRecord.new(options)
  end

  def create_after_registration(member)
    Collaborations.create_after_registration(member)
  end

  def welcome_email_to(email, collaboration)
    FakeChallengeMailer::Mail.new(email, collaboration)
  end

  def deliveries
    FakeChallengeMailer.deliveries
  end

  def collaboration_for(member, challenge)
    { member_id: member.id, challenge_id: challenge.id }
  end

  def last_challenge
    Collaborations.last_challenge
  end

  def collaborations
    Collaborations.store.all
  end
end
