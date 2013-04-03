class CommentsController < ApplicationController

	def create
		@project = Project.find(params[:project_id])
		@comment = Comment.build_from(@project, current_user.id, params[:comment][:body])
		if @comment.save
			redirect_to project_path(@project, anchor: 'comments'), notice: t('comments.commented')
		else
			redirect_to project_path(@project, anchor: 'comments'), error: t('comments.failure')
		end
	end

	def like
		@comment = Comment.find(params[:id])
		@project = Project.find(params[:project_id])
		if params[:like].present?
    	current_user.vote_for(@comment)
    else
    	current_user.vote_against(@comment)
    end
    @comment.update_votes_counter
    redirect_to @project, notice: t('comments.voted')
	end

	def reply
		@project = Project.find(params[:project_id])
		@reply = Comment.build_from(@project, current_user.id, params[:comment][:body])
		parent_comment = Comment.find(params[:parent])
		if @reply.save
			@reply.move_to_child_of(parent_comment)
			redirect_to project_path(@project, anchor: 'comments'), notice: t('comments.commented')
		else
			redirect_to project_path(@project, anchor: 'comments'), error: t('comments.failure')
		end
	end

end
