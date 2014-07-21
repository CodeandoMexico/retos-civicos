require_relative '../../app/services/collaborations'

describe Collaborations do
  before do
    FakeChallengeMailer.clear_deliveries!

    Collaborations.config = {
      store: FakeCollaborationsStore.new,
      mailer: FakeChallengeMailer.new,
      challenges_store: FakeChallengeStore.new
    }
  end

  it 'creates collaboration without sending email' do
    member = MemberRecord.new('juanito@example.com')
    challenge = ChallengeRecord.new(welcome_mail: 'Hola')

    Collaborations.create_without_email(member, challenge)
    collaborations.should include collaboration_for(member, challenge)
    deliveries.should be_empty
  end

  it 'does not create a collaboration if there is one already' do
    member = MemberRecord.new('juanito@example.com')
    challenge = ChallengeRecord.new(welcome_mail: 'Hola')

    Collaborations.create_without_email(member, challenge)
    Collaborations.create_without_email(member, challenge)

    collaborations.count.should eq 1
  end

  describe 'creates collaboration after registration' do
    attr_reader :member

    before do
      @member = MemberRecord.new
    end

    it 'creates the collaboration if just one challenge exists' do
      Collaborations.challenges_store.push(ChallengeRecord.new)

      create_after_registration(member)
      collaborations.should include collaboration_for(member, last_challenge)
    end

    it 'does not create a collaboration if more than one challenge exist' do
      Collaborations.challenges_store.push(ChallengeRecord.new, ChallengeRecord.new)

      create_after_registration(member)
      collaborations.should be_empty
    end

    it 'does not create a collaboration if there is one already' do
      Collaborations.challenges_store.push(ChallengeRecord.new)

      create_after_registration(member)
      create_after_registration(member)

      collaborations.count.should eq 1
    end

    describe 'and sends welcome email' do
      it 'when the member and challenge have email' do
        member = MemberRecord.new('juanito@example.com')
        Collaborations.challenges_store.push(ChallengeRecord.new(welcome_mail: 'Hola!'))

        collaboration = create_after_registration(member)
        deliveries.should include welcome_email_to('juanito@example.com', collaboration)
      end

      it 'but not when the user has no email' do
        member = MemberRecord.new('')
        Collaborations.challenges_store.push(ChallengeRecord.new(welcome_mail: 'Hola!'))

        collaboration = create_after_registration(member)
        deliveries.should be_empty
      end

      it 'but not when the challenge has no welcome mail' do
        member = MemberRecord.new('juanito@example.com')
        Collaborations.challenges_store.push(ChallengeRecord.new(welcome_mail: ''))

        collaboration = create_after_registration(member)
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

  class ChallengeRecord
    attr_reader :id, :welcome_mail

    def initialize(welcome_mail: '')
      @id = SecureRandom.uuid
      @welcome_mail = welcome_mail
    end
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
      all.select do |record|
        record == { member_id: member_id, challenge_id: challenge_id }
      end.first
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
