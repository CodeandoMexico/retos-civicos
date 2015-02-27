class OrganizationMailer < ActionMailer::Base
  default from: ENV['MAILER_DEFAULT_FROM']

  def send_newsletter_to_collaborator(collaborator, organization, title, message)
    @organization = organization
    @collaborator = collaborator
    @message = message

    mail to: @collaborator.member.email, subject: "[#{@organization.name}] #{title}"
  end

  def judge_finished_evaluating(evaluation)
    @evaluation = evaluations
    mail to: evaluation.challenge.organization.email, subject: I18n.t('.a_judge_has_finished_evaluating_a_challenge')
  end
end
