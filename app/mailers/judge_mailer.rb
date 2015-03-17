#encoding: utf-8
class JudgeMailer < ActionMailer::Base
  default from: ENV['MAILER_DEFAULT_FROM']
  add_template_helper(ApplicationHelper)

  def new_account(user)
    @user = user
    mail to: @user.email, subject: "Cuenta de juez creada"
  end

  def invited_to_challenge(evaluation)
    @evaluation = evaluation
    @user = evaluation.judge.user
    mail to: @user.email, subject: "Comité de evaluación del Reto \"#{@evaluation.challenge.title}\""
  end
end
