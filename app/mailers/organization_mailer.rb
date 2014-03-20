class OrganizationMailer < ActionMailer::Base
  default from: "Codeando México <equipo@codeandomexico.org>"

  def send_newsletter_to_collaborator(collaborator, organization, title, message)
    @organization = organization
    @collaborator = collaborator
    @message = message

    mail to: @collaborator.member.email,
      subject: "[#{@organization.name}] #{title}"
  end
end
