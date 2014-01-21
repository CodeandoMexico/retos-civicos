require 'spec_helper'

describe CommentMailer do

  describe ".create_comment_notification" do

    let!(:comment) { FactoryGirl.create(:comment) }
    let!(:organization) { comment.commentable.organization }
    let!(:user) { FactoryGirl.create(:user, userable: organization) }
    let!(:mail) { CommentMailer.create_comment_notification(comment.id) }


    it "should send the email" do
      reset_email
      mail.deliver!
      ActionMailer::Base.deliveries.size.should be 1
    end

    it "should send an email to the organization" do
      expect(mail.to).to eq( [organization.email] )
    end

    it "should send an email from" do
      expect( mail.from ).to eq( ['equipo@codeandomexico.org'] )
    end

    it "should expect subject to be 'Tienes un nuevo comentario" do
      expect( mail.subject ).to eq( "Tienes un nuevo comentario")
    end
  end

  describe ".reply_comment_notification" do
    let!(:parent_comment) { FactoryGirl.create(:comment) }
    let!(:comment) { FactoryGirl.create(:comment, parent: parent_comment, commentable: parent_comment.commentable) }
    let(:mail) { CommentMailer.reply_comment_notification(comment.id) }

    it "should send the email" do
      reset_email
      mail.deliver!
      ActionMailer::Base.deliveries.size.should be 1
    end

    it "should send an email to parent comment creator" do
      expect( mail.to.first ).to eq( parent_comment.user.email )
    end

    it "should send an email from" do
      from = "equipo@codeandomexico.org"
      expect( mail.from ).to eq( [from] )
    end

    it "should expect subject to be 'Tienes una nueva respuesta en un comentario" do
      expect( mail.subject ).to eq( "Tienes una nueva respuesta en un comentario")
    end
  end
end
