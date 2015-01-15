module Dashboard
  class BaseController < ApplicationController
    layout 'dashboard'
    before_filter :authenticate_current_user!
    before_filter :authenticate_organization_admin!
    before_filter :pending_winner_flash_message

    def pending_winner_flash_message
      challenges = Challenge.missing_winner_challenges(organization: current_organization)
      flash.now[:alert] = [] unless flash.now[:alert]
      challenges.each do |challenge|
        flash.now[:alert] << t('flash.base.select-winner', title: challenge.title, link: view_context.link_to('seleccionarlo aquí', dashboard_entries_path(challenge_id: challenge.id)))
      end
    end

    def authenticate_current_user!
      redirect_to challenges_path unless current_user
    end

    def authenticate_organization_admin!
      redirect_to challenges_path unless current_user.organization?
    end

    helper_method :organization

    def organization
      @_organization ||= current_user.userable
    end

    def organization_challenges
      @_organization_challenges ||= organization.challenges.order('created_at DESC')
    end

    def current_challenge
      @_current_challenge ||= begin
        organization_challenges.find_by_id(params[:challenge_id]) ||
          organization_challenges.first
      end
    end

    def require_current_challenge
      render 'no_challenge' unless current_challenge
    end

    def dashboard_csv_for(record_class, collection)
      reporter = CsvReporter.new(record_class, collection, translator: self)
      reporter.report_for_organization(organization)
    end
  end
end
