class ReportCardsController < ApplicationController
  layout 'judges'
  before_filter :set_report_card, only: :update
  before_filter :set_evaluation, only: :update

  def update
    if @report_card.update_attributes(grades:params[:grades])
      flash[:notice] = if @report_card.entry.next.nil?
        I18n.t('report_cards.evaluation_has_been_saved_successfully')
      else
        I18n.t('report_cards.evaluation_has_been_saved_successfully_go_to_next',
              href: evaluations_path(challenge_id: @report_card.evaluation.challenge,
                            entry_id:  @report_card.entry.next))
      end
    else
      flash[:alert] = I18n.t('report_cards.there_was_an_error_while_saving_the_evaluation')
    end
    redirect_to evaluations_path(challenge_id: @current_challenge, entry_id: params[:entry_id])
  end

  private

  def set_report_card
    @report_card ||= ReportCard.find(params[:id])
  end

  def set_evaluation
    @evaluation ||= Evaluation.find(params[:evaluation_id])
  end
end
