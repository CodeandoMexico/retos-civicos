class CommentMailer < ActionMailer::Base

  helper :application

  default from: "Codeando México <equipo@codeandomexico.org>"

  def create_comment_notification(comment_id)
    @comment = Comment.find(comment_id)
    @challenge = @comment.commentable
    @organization = @challenge.organization

    mail to: @organization.email, subject: 'Tienes un nuevo comentario'
  end

  def reply_comment_notification(son_comment_id)
    @comment = Comment.find(son_comment_id)
    @user = @comment.parent.user
    @challenge =  @comment.commentable

    mail to: @user.email, subject: 'Tienes una nueva respuesta en un comentario'
  end

end
