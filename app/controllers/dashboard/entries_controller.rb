require 'csv'

module Dashboard
  class EntriesController < Dashboard::BaseController
    def index
      @challenges = organization_challenges
      @current_challenge = current_challenge
      @entries = current_challenge.entries.order('created_at DESC').includes(:challenge, member: :user)

      respond_to do |format|
        format.html
        format.csv { send_data entries_csv(@entries) }
      end
    end

    def show
      @entry = entry
    end

    def publish
      entry.publish!
      entry.save
      redirect_to dashboard_entries_path(challenge_id: current_challenge.id)
    end

    private

    def entry
      @cached_entry ||= Entry.find(params[:id])
    end

    def organization_challenges
      @organization_challenges ||= organization.challenges.order('created_at DESC')
    end

    def current_challenge
      @current_challenge ||= begin
        organization_challenges.find_by_id(params[:challenge_id]) ||
          organization_challenges.first
      end
    end

    def entries_csv(entries)
      CSV.generate do |csv|
        csv << entries_csv_headers(entries)
        entries.each { |entry| csv << entry.to_report }
      end
    end

    def entries_csv_headers(entries)
      csv_headers = I18n.t('entries.csv_headers')
      entries.report_attributes.map { |attribute| csv_headers.fetch(attribute) }
    end
  end
end
