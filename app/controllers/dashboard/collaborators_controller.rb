module Dashboard
  class CollaboratorsController < Dashboard::BaseController
    before_filter :require_current_challenge, only: :index
    add_crumb 'Participantes'

    def index
      @challenges = organization_challenges
      @current_challenge = current_challenge
      @collaborators = current_challenge_collaborators

      respond_to do |format|
        format.html
        format.csv { send_data *dashboard_csv_for(Member, @collaborators) }
      end
    end

    private

    def current_challenge_collaborators
      current_challenge.collaborations.
        includes(:member).
        order('created_at DESC').
        map(&:member).
        compact
    end
  end
end
