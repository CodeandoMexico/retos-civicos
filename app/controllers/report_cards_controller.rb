class ReportCardsController < ApplicationController
  layout 'judges'
  before_filter :set_report_card, only: :update
  before_filter :set_evaluation, only: :update

  def update
    # TODO: Refactor this update attributes to be more secure and slim it!
    authorize! :update, @report_card
    grades = params[:grades]
    comments = params[:comments]
    feedback = params[:feedback]
    if @report_card.update_attributes(grades: grades, comments: comments, feedback: feedback)
      flash[:notice] = if @report_card.next.nil?
                         I18n.t('report_cards.evaluation_has_been_saved_successfully')
                       else
                         I18n.t('report_cards.evaluation_has_been_saved_successfully_go_to_next',
                                href: evaluations_path(challenge_id: @report_card.evaluation.challenge,
                                                       report_card_id:  @report_card.next))
                       end

      # send an email to the organization if a judge has finished evaluation
      if @report_card.evaluation.finished?
        OrganizationMailer.judge_finished_evaluating(@report_card.evaluation).deliver
      end

      # check if this entry is finished being evaluated
      EntriesMailer.delay.entry_evaluated(@report_card.entry) if @report_card.entry.evaluated?
    else
      flash[:alert] = I18n.t('report_cards.there_was_an_error_while_saving_the_evaluation')
    end
    challenge_id = @report_card.evaluation.challenge
    redirect_to evaluations_path(challenge_id: challenge_id, report_card_id: @report_card)
  end

  private

  def set_report_card
    @report_card ||= ReportCard.find(params[:id])
  end

  def set_evaluation
    @evaluation ||= Evaluation.find(params[:evaluation_id])
  end
end
