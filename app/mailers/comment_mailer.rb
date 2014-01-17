class CommentMailer < ActionMailer::Base

  helper :application

  default from: "Codeando México <equipo@codeandomexico.org>"

  def reply_comment_notification(son_comment_id)
    @comment = Comment.find(son_comment_id)
    @user = @comment.parent.user
    @challenge =  @comment.commentable

    mail to: @user.email, subject: 'Tienes una nueva respuesta en un comentario'
  end

end
