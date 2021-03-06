module Dashboard
  class BaseController < ApplicationController
    layout 'dashboard'
    before_filter :authenticate_current_user!
    before_filter :pending_winner_flash_message
    add_crumb 'Dashboard', '/dashboard'

    def pending_winner_flash_message
      fetch_pending_challenges_flash_messages_for(current_organization) if current_user.organization?
    end

    def authenticate_current_user!
      redirect_to challenges_path unless current_user
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

    def fetch_pending_challenges_flash_messages_for(_organization)
      challenges = Challenge.missing_winner_challenges(organization: current_organization)
      return unless challenges.present?
      if flash.now[:alert].present?
        flash.now[:alert] = [flash.now[:alert]]
      else
        flash.now[:alert] ||= []
      end
      link_text = 'seleccionarlo aquí'
      challenges.each do |challenge|
        entries_link = view_context.link_to(link_text, dashboard_entries_path(challenge_id: challenge.id))
        flash.now[:alert] << t('flash.base.select-winner', title: challenge.title, link: entries_link)
      end
      flash.now[:alert] = flash[:alert].join('<br>').html_safe if flash[:alert].is_a?(Array)
    end
  end
end
