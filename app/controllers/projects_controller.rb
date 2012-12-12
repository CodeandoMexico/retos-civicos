class ProjectsController < ApplicationController

  before_filter :save_location, only: [:new]
  before_filter :save_previous, only: [:collaborate, :like]
  before_filter :authorize!, except: [:index, :show, :timeline]

	def index
		@projects = Project.all
	end

  def new
  	@project = Project.new
  end

  def show
  	@project = Project.find(params[:id])
    @comments = @project.root_comments
  end

  def edit
  	@project = current_user.created_projects.find(params[:id])
    @activity = @project.activities.build
  end

  def create
		@project = current_user.created_projects.build(params[:project])
    Collaboration.create(user: current_user, project: @project)
		if @project.save
		  redirect_to @project
		else
		  render :new
		end
  end

  def update
  	@project = current_user.created_projects.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to @project
    else
      render :edit
    end
  end

  def cancel
  	@project = current_user.created_projects.find(params[:id])
  	@project.cancel!
  	redirect_to projects_url
  end

  def collaborate
    @project = Project.find(params[:id])
    Collaboration.create(user: current_user, project: @project)
    redirect_to @project
  end

  def like
    @project = Project.find(params[:id])
    current_user.vote_for(@project)
    @project.update_likes_counter
    redirect_to @project
  end

  def timeline
    @project = Project.find(params[:id])
    render json: @project.timeline_json
  end

  private

  def save_location
    store_location unless signed_in?
  end

end
