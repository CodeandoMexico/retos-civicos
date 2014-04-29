module Dashboard
  class BaseController < ApplicationController
    layout 'dashboard'
    before_filter :authenticate_current_user!
    before_filter :authenticate_organization_admin!

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

    def dashboard_csv_for(record_class, collection)
      CSV.generate do |csv|
        csv << dashboard_csv_headers(record_class)
        collection.each { |record| csv << record.to_report }
      end
    end

    def dashboard_csv_headers(record_class)
      csv_headers = I18n.t("#{record_class.to_s.pluralize.underscore}.csv_headers")
      record_class.report_attributes.map { |attribute| csv_headers.fetch(attribute) }
    end
  end
end
