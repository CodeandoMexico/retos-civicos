require 'spec_helper'

describe Comment do

  describe "methods" do
    let!(:comment) { FactoryGirl.create(:comment) }
    describe "#update_votes_counter" do
      it "should run without errors" do
        comment.update_votes_counter
      end
    end

    describe ".find_commentable" do
      it "should return the comment related to the id" do
        comment_from_commentable = Comment.find_commentable('Comment', comment.id)
        expect(comment_from_commentable).to eq comment
      end
    end
  end
end
