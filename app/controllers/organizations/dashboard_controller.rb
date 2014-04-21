module Organizations
  class DashboardController < ApplicationController
    layout 'organizations/dashboard'

    before_filter :authenticate_organization_admin!

    def index
    end

    private

    def authenticate_organization_admin!
      unless current_user
        redirect_to challenges_path
      end
    end
  end
end
