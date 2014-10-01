class ChallengesController < ApplicationController
  load_and_authorize_resource through: :current_organization, except: [:index, :show, :timeline, :like]

  before_filter :save_location, only: [:new, :show]
  before_filter :save_previous, only: [:like]

  def index
    # comment next two lines to enable aquila default behavior
    # TO-DO: remove next line. is a temporary redirect to avoid crash on DB clean state
    return redirect_to about_path if Challenge.count.zero?
    return redirect_to challenge_path(last_challenge) if Challenge.has_only_one_challenge?

    ch = Challenge.active.recent
    ch = Challenge.active if params[:active]
    ch = Challenge.inactive if params[:inactive]
    ch = Challenge.popular if params[:popular]
    @challenges = ch.page(params[:page])
    @challenges_group = @challenges.in_groups_of(3, false)
    render layout: 'aquila'
  end

  def new
    render layout: 'aquila'
  end

  def show
    @challenge = Challenge.find(params[:id], include: [:comment_threads, { :collaborators => { :user => :authentications }}])

    if @challenge.is_public? || User.is_admin_of_challenge(@challenge, current_organization)
      @organization = @challenge.organization
      @comments = fetch_comments
      @entries = @challenge.entries.public
      @datasets = @challenge.datasets
      @collaborators = @challenge.collaborators
      @timeline = Phases.timeline_from_dates(@challenge)
      @current_phase_title = Phases.current_phase_title(@challenge)
      @days_left_for_current_phase = Phases.days_left_for_current_phase(@challenge)

      @collaborators_count = @collaborators.count
      @collaborators = @collaborators.order(:created_at).page(params[:page])

      @winner = @challenge.current_winner
      @finalists = @challenge.current_finalists
      return render layout: 'aquila'
    end

    return render :file => 'public/404', :status => :not_found, :layout => false
  end

  def edit
    @activity = @challenge.activities.build
    render layout: 'aquila'
  end

  def create
    if @challenge.save
      redirect_to organization_challenge_path(@challenge.organization, @challenge)
    else
      render :new, layout: 'aquila'
    end
  end

  def update
    if @challenge.update_attributes(params[:challenge])
      redirect_to organization_challenge_path(@challenge.organization, @challenge)
    else
      render :edit, layout: 'aquila'
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
