class CommentsController < ApplicationController
  load_and_authorize_resource :comment, only: [:like]

  def create
    @challenge = Challenge.find(params[:challenge_id])
    authorize! :create_or_reply_challenge_comment, @challenge
    @comment = Comment.build_from(@challenge, current_user.id, params[:comment][:body])
    if @comment.save
      CommentMailer.delay.create_comment_notification(@comment.id)
      respond_to do |format|
        format.js
        format.html { redirect_to organization_challenge_path(@challenge.organization, @challenge, anchor: 'comment'), notice: t('comments.commented') }
      end
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
    respond_to do |format|
      format.js
      format.html { redirect_to organization_challenge_path(@challenge.organization, @challenge), notice: t('comments.voted') }
    end
  end

  def reply
    @challenge = Challenge.find(params[:challenge_id])
    authorize! :create_or_reply_challenge_comment, @challenge
    @reply = Comment.build_from(@challenge, current_user.id, params[:comment][:body])
    parent_comment = Comment.find(params[:parent])
    if @reply.save
      @reply.move_to_child_of(parent_comment)
      CommentMailer.delay.reply_comment_notification(@reply.id)
      redirect_to organization_challenge_path(@challenge.organization, @challenge, anchor: 'comment'), notice: t('comments.commented')
    else
      redirect_to organization_challenge_path(@challenge.organization, @challenge, anchor: 'comment'), notice: t('comments.failure')
    end
  end

end
