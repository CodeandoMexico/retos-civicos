class OrganizationMailer < ActionMailer::Base
  default from: ENV['MAILER_DEFAULT_FROM']

  def send_newsletter_to_collaborator(collaborator, organization, title, message)
    @organization = organization
    @collaborator = collaborator
    @message = message

    mail to: @collaborator.member.email, subject: "[#{@organization.name}] #{title}"
  end

  def judge_finished_evaluating(evaluation)
    @evaluation = evaluation
    challenge = evaluation.challenge.title
    title = I18n.t('evaluations.mailer.a_judge_has_finished_evaluating_a_challenge', challenge: challenge)

    mail to: evaluation.challenge.organization.email, subject: title
  end
end
