class ProjectsController < ApplicationController

	def index
		@projects = Project.all
	end

  def new
  	@project = Project.new
  end

  def show
  	@project = Project.find(params[:id])
  end

  def edit
  	@project = current_user.created_projects.find(params[:id])
  end

  def create
		@project = current_user.created_projects.build(params[:project])
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
  	@project = current_user.created_projects.find(params[:project_id])
  	@project.cancel!
  	redirect_to projects_url
  end

end
