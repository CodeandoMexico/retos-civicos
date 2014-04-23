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

    def organization
      @cached_organization ||= current_user.userable
    end
  end
end
