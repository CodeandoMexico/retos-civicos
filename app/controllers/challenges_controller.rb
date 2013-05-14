class ChallengesController < ApplicationController

  before_filter :save_location, only: [:new]
  before_filter :save_previous, only: [:collaborate, :like]
  before_filter :authorize_user!, except: [:index, :show, :timeline]

	def index
		@challenges = Challenge.all
	end

  def new
  	@challenge = Challenge.new
    authorize! :create, @challenge
  end

  def show
  	@challenge = Challenge.find(params[:id])
    @comments = @challenge.root_comments.sort_parents
  end

  def edit
  	@challenge = current_user.created_challenges.find(params[:id])
    @activity = @challenge.activities.build
  end

  def create
		@challenge = current_user.created_challenges.build(params[:challenge])
    Collaboration.create(user: current_user, challenge: @challenge)
		if @challenge.save
		  redirect_to @challenge
		else
		  render :new
		end
  end

  def update
  	@challenge = current_user.created_challenges.find(params[:id])
    if @challenge.update_attributes(params[:challenge])
      redirect_to @challenge
    else
      render :edit
    end
  end

  def cancel
  	@challenge = current_user.created_challenges.find(params[:id])
  	@challenge.cancel!
  	redirect_to challenges_url
  end

  def collaborate
    @challenge = Challenge.find(params[:id])
    current_member.collaborations.create(challenge: @challenge)
    redirect_to @challenge, notice: t('challenges.collaborating')
  end

  def like
    @challenge = Challenge.find(params[:id])
    current_user.vote_for(@challenge)
    @challenge.update_likes_counter
    redirect_to @challenge, notice: t('comments.voted')
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
