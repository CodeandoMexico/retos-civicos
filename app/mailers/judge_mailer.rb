#encoding: utf-8
class JudgeMailer < ActionMailer::Base
  default from: ENV['MAILER_DEFAULT_FROM']

  def new_account(user)
    @user = user
    mail to: @user.email, subject: "Cuenta de juez creada"
  end
end
