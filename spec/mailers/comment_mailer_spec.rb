require 'spec_helper'

describe CommentMailer do

  let!(:parent_comment) { FactoryGirl.create(:comment) }
  let!(:comment) { FactoryGirl.create(:comment, parent: parent_comment, commentable: parent_comment.commentable) }

  describe ".reply_comment_notification" do
    let(:mail) { CommentMailer.reply_comment_notification(comment.id) }

    it "should send the email" do
      #Since user creation sends an email, we need to clear the array just before
      ActionMailer::Base.deliveries.clear
      mail.deliver!
      ActionMailer::Base.deliveries.size.should == 1
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
