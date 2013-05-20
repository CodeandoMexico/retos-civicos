class CommentsController < ApplicationController
  load_and_authorize_resource :comment, only: [:like]

	def create
		@challenge = Challenge.find(params[:challenge_id])
    authorize! :create_or_reply_challenge_comment, @challenge
		@comment = Comment.build_from(@challenge, current_user.id, params[:comment][:body])
		if @comment.save
      redirect_to organization_challenge_path(@challenge.organization, @challenge, anchor: 'comment'), notice: t('comments.commented')
		else
      redirect_to organization_challenge_path(@challenge.organization, @challenge, anchor: 'comment'), notice: t('comments.failure')
		end
	end

	def like
		@challenge = Challenge.find(params[:challenge_id])
		if params[:like].present?
    	current_user.vote_for(@comment)
    else
    	current_user.vote_against(@comment)
    end
    @comment.update_votes_counter
    redirect_to organization_challenge_path(@challenge.organization, @challenge), notice: t('comments.voted')
	end

	def reply
		@challenge = Challenge.find(params[:challenge_id])
    authorize! :create_or_reply_challenge_comment, @challenge
		@reply = Comment.build_from(@challenge, current_user.id, params[:comment][:body])
		parent_comment = Comment.find(params[:parent])
		if @reply.save
			@reply.move_to_child_of(parent_comment)
      redirect_to organization_challenge_path(@challenge.organization, @challenge, anchor: 'comment'), notice: t('comments.commented')
		else
      redirect_to organization_challenge_path(@challenge.organization, @challenge, anchor: 'comment'), notice: t('comments.failure')
		end
	end

end
