require 'spec_helper'

describe OrganizationMailer do

  describe ".send_newsletter_to_collaborator" do

    let!(:organization) { new_organization }
    let!(:challenge) { FactoryGirl.create(:challenge, organization: organization) }
    let!(:members) { FactoryGirl.create_list(:user, 5).map(&:userable) }

    before do
      members.each do |member|
        member.collaborations.create(challenge: challenge)
      end
      reset_email
      Collaboration.all.each do |collaborator|
        OrganizationMailer.send_newsletter_to_collaborator(collaborator, organization, "subject text", "body text").deliver
      end
    end

    let!(:mails) { ActionMailer::Base.deliveries }
    let!(:collaborators) { Collaboration.all }

    it "should send the email" do
      ActionMailer::Base.deliveries.size.should be 5
    end

    it "should send an email to each member" do
      mails.each_with_index do |mail, index|
	expect(mail.to).to eq( [collaborators[index].member.email])
      end
    end

    it "should send an email from" do
      expect(mails.first.from ).to eq( ['equipo@codeandomexico.org'])
    end

    it "should expect subject to be the one the user specified" do
      email_subject = "[#{organization.name}] subject text"
      expect(mails.first.subject).to eq(email_subject)
    end

    it "should contain body user greeting" do
      user = collaborators.first.member.email.split('@')[0]
      expect(mails.first.body.raw_source).to include(user)
    end

    it "should contain body text" do
      expect(mails.first.body.raw_source).to include("body text")
    end
  end
end
