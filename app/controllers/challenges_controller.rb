class ChallengesController < ApplicationController

  before_filter :save_location, only: [:new]
  before_filter :save_previous, only: [:like]
  before_filter :authorize_user!, except: [:index, :show, :timeline]

	def index
		@challenges = Challenge.all
	end

  def new
  	@challenge = current_organization.challenges.build
    #authorize! :create, @challenge
  end

  def show
    @organization = Organization.find(params[:organization_id])
  	@challenge = @organization.challenges.find(params[:id])
    @comments = @challenge.root_comments.sort_parents
  end

  def edit
  	@challenge = current_organization.challenges.find(params[:id])
    @activity = @challenge.activities.build
  end

  def create
		@challenge = current_organization.challenges.build(params[:challenge])
		if @challenge.save
		  redirect_to organization_challenge_path(@challenge.organization, @challenge)
		else
		  render :new
		end
  end

  def update
  	@challenge = current_organization.challenges.find(params[:id])
    if @challenge.update_attributes(params[:challenge])
		  redirect_to organization_challenge_path(@challenge.organization, @challenge)
    else
      render :edit
    end
  end

  def cancel
  	@challenge = current_organization.challenges.find(params[:id])
  	@challenge.cancel!
  	redirect_to challenges_url
  end

  def like
    @challenge = Challenge.find(params[:id])
    current_user.vote_for(@challenge)
    @challenge.update_likes_counter
    redirect_to organization_challenge_path(@challenge.organization, @challenge), notice: t('comments.voted')
  end

  def timeline
    @challenge = Challenge.find(params[:id])
    render json: @challenge.timeline_json
  end

  private

  def save_location
    store_location unless signed_in?
  end

end
