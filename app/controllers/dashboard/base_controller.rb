module Dashboard
  class BaseController < ApplicationController
    layout 'dashboard'
    before_filter :authenticate_current_user!
    before_filter :authenticate_organization_admin!

    def authenticate_current_user!
      redirect_to challenges_path unless current_user
    end

    def authenticate_organization_admin!
      unless organization.subdomain == request.subdomains.first
        redirect_to dashboard_url(subdomain: organization.subdomain)
      end
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
  end
end
