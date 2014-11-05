class JudgesController < ApplicationController
  layout 'judges'
  before_filter :authenticate_user!
  before_filter :authenticate_judge!

  def show
    @judge = current_user.userable
  end

  private

  def authenticate_judge!
    current_user.judge?
  end
end
