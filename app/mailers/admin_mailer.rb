#encoding: utf-8
class AdminMailer < ActionMailer::Base
  default from: "hubot@codeandomexico.org"

  def notify_new_organization(organization)
    @organization = organization

    mail to: "equipo@codeandomexico.org", subject: "Nueva organizacion registrada"
  end
end
