class ChallengesController < ApplicationController
  load_and_authorize_resource through: :current_organization, except: [:index, :show, :timeline, :like]

  before_filter :save_location, only: [:new, :show]
  before_filter :save_previous, only: [:like]

  def index
    ch = Challenge.recent
    ch = Challenge.active if params[:active]
    ch = Challenge.inactive if params[:inactive]
    ch = Challenge.popular if params[:popular]
    @challenges = ch.page(params[:page]).per(12)
  end

  def new
  end

  def show
    @challenge = Challenge.find(params[:id], include: [:comment_threads, { :collaborators => { :user => :authentications }}])
    @organization = @challenge.organization
    @comments = @challenge.root_comments.sort_parents
    @entries = @challenge.entries
    @collaborators = @challenge.collaborators.order(:created_at).page(params[:page])
  end

  def edit
    @activity = @challenge.activities.build
  end

  def create
    if @challenge.save
      redirect_to organization_challenge_path(@challenge.organization, @challenge)
    else
      render :new
    end
  end

  def update
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
    authorize! :like, Challenge
    @challenge = Challenge.find(params[:id])
    current_user.vote_for(@challenge)
    @challenge.update_likes_counter
    respond_to do |format|
      format.js
      format.html { redirect_to organization_challenge_path(@challenge.organization, @challenge), notice: t('comments.voted') }
    end
  end

  def timeline
    @challenge = Challenge.find(params[:id])
    render json: @challenge.timeline_json
  end

  def send_newsletter
  end

  def mail_newsletter
    challenge = Challenge.find(params[:id])
    challenge.collaborations.each do |collaborator|
      OrganizationMailer.delay.send_newsletter_to_collaborator(collaborator, challenge.organization, params[:subject], params[:body])
    end

    redirect_to challenge_path(challenge), notice: t('flash.organizations.send')
  end

  private

  def save_location
    store_location unless user_signed_in?
  end

  def save_previous
    store_location(request.referer) unless user_signed_in?
  end

end
