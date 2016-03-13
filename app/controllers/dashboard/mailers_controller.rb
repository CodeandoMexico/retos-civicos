module Dashboard
  class MailersController < Dashboard::BaseController
    before_filter :prepare_everything

    def new
    end

    def finalists
    end

    def participants
    end

    def create
      if valid_email_params?
        collaborators = Member.find_all_by_id(parse_members) if params[:members]
        collaborators ||= current_challenge.collaborators
        send_email_to_collaborators(collaborators)
        notice_text = t('flash.mailers.create.notice')
        redirect_to dashboard_collaborators_path, notice: notice_text
      else
        alert_text = t('flash.mailers.create.alert')
        redirect_to new_dashboard_challenge_email_path(current_challenge), alert: alert_text
      end
    end

    private

    def parse_members
      params[:members].reject { |_k, v| v == '0' }.keys
    end

    def send_email_to_collaborators(collaborators)
      subject = email_params[:subject]
      body = email_params[:body]
      collaborators.each do |collaborator|
        email = collaborator.email
        ChallengeMailer.delay.custom_message_to_all_collaborators(email, subject, body)
      end
    end

    def prepare_everything
      @email = { subject: '', body: '' }
      @challenges = organization_challenges
      @current_challenge = current_challenge
      @collaborators = current_challenge_collaborators
    end

    def email_params
      params[:email].slice(:subject, :body)
    end

    def valid_email_params?
      email_params[:subject].present? && email_params[:body].present?
    end

    def current_challenge_collaborators
      current_challenge.collaborations.includes(:member)
                                      .order('created_at DESC')
                                      .map(&:member)
                                      .compact
    end
  end
end
