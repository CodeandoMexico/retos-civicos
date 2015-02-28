class JudgesController < ApplicationController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!

  def show
    @judge = current_user.userable
  end

  def edit
    @judge = Judge.find(params[:id])
    render layout: 'aquila'
  end

  def update
    @judge = Judge.find(params[:id])
    if @judge.update_attributes(params[:judge])
      redirect_to challenges_path, notice: t('flash.users.updated')
    else
      render :edit, layout: 'aquila'
    end
  end

  private

  def authenticate_judge!
    current_user.judge?
  end
end
