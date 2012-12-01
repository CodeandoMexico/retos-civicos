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
  	@project = Project.find(params[:id])
  end

  def create
		@project = Project.new(params[:project]) 
		if @project.save
		  redirect_to @project
		else
		  render :new
		end
  end

  def update
  	@project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to @project
    else
      render :edit
    end
  end

  def cancel
  	@project = Project.find(params[:project_id])
  	@project.cancel!
  	redirect_to projects_url
  end

end
