module Dashboard
  class BaseController < ApplicationController
    layout 'dashboard'
    before_filter :authenticate_organization_admin!

    def organization
      current_user.userable
    end

    def authenticate_organization_admin!
      unless current_user
        redirect_to challenges_path
      end
    end
  end
end
