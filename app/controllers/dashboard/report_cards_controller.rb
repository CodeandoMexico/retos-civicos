module Dashboard
  class ReportCardsController < Dashboard::BaseController
    before_filter :set_current_challenge

    def index
      @challenges = organization.challenges.sorted
      flash[:warning] = (@current_challenge.ready_to_rank_entries? && !@current_challenge.finished_evaluating?) ?
                        I18n.t('dashboard.report_cards.index.not_all_judges_are_finished_evaluating') :
                        nil
    end

    def show
      @report_card = ReportCard.find(params[:id])
    end

    private

    def set_current_challenge
      @current_challenge = current_challenge
    end
  end
end
