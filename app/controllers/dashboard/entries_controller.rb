require 'csv'

module Dashboard
  class EntriesController < Dashboard::BaseController
    def index
      @challenges = organization_challenges
      @current_challenge = current_challenge
      @entries = current_challenge.entries.order('created_at DESC').includes(:challenge, member: :user)

      respond_to do |format|
        format.html
        format.csv { send_data dashboard_csv_for(Entry, @entries) }
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
      @_entry ||= Entry.find(params[:id])
    end
  end
end
