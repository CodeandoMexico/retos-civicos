class ReportCardsController < ApplicationController
  layout 'judges'
  before_filter :set_report_card, only: :update
  before_filter :set_evaluation, only: :update

  def update
    # raise params.inspect
    if @report_card.save
      flash[:notice] = I18n.t('report_cards.evaluation_has_ben_saved_successfully')
    else
      flash[:alert] = I18n.t('report_cards.there_was_an_error_while_saving_the_evaluation')
    end

    redirect_to evaluations_path
  end

  private

  def set_report_card
    @report_card ||= ReportCard.find(params[:id])
  end

  def set_evaluation
    @evaluation ||= Evaluation.find(params[:evaluation_id])
  end
end
