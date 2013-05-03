class OpenDataZapopan::ChallengesController < ApplicationController
  def index
    @challenges = Challenge.in_zapopan
  end
end
