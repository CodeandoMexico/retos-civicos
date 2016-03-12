class ChallengesController < ApplicationController
  load_and_authorize_resource through: :current_organization, except: [:index, :show, :timeline, :like]

  before_filter :save_location, only: [:new, :show]
  before_filter :save_previous, only: [:like]

  def index
    @challenges = Challenge.order('created_at DESC').page(params[:page]).includes(:organization)
    render layout: 'aquila'
  end

  def show
    @challenge = Challenge.find(params[:id])

    if @challenge.public? || User.is_admin_of_challenge(@challenge, current_organization)
      @organization = @challenge.organization
      @comments = fetch_comments
      @entries = @challenge.entries.public
      @datasets = @challenge.datasets
      @collaborators = @challenge.collaborators
      @timeline = Phases.timeline_from_dates(@challenge)
      @current_phase_title = Phases.current_phase_title(@challenge).title
      @days_left_for_current_phase = Phases.days_left_for_current_phase(@challenge)

      @collaborators_count = @collaborators.count
      @collaborators = @collaborators.order(:created_at).page(params[:page])

      @winners = @challenge.current_winners
      @finalists = @challenge.current_finalists
      return render layout: 'aquila'
    end

    record_not_found
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

  def fetch_comments
    comments_per_page = 10
    current_page = params[:page]
    # r = most recent and v = vote count
    return @challenge.root_comments.most_recent.page(current_page).per(comments_per_page) if params[:order_by] == 'recent'
    @challenge.root_comments.sort_parents.page(current_page).per(comments_per_page)
  end

  def save_location
    store_location unless user_signed_in?
  end

  def save_previous
    store_location(request.referer) unless user_signed_in?
  end
end
