# BrigadeProjectsController directs CRUD actions for all
# BrigadeProjects
class BrigadeProjectsController < ApplicationController
  # GET /brigade_projects
  # GET /brigade_projects.json
  def index
    @brigade_projects = BrigadeProject.all
    general_static_response(@brigade_projects)
  end

  # GET /brigade_projects/1
  # GET /brigade_projects/1.json
  def show
    @brigade_project = BrigadeProject.find(params[:id])
    general_static_response(@brigade_project)
  end

  # GET /brigade_projects/new
  # GET /brigade_projects/new.json
  def new
    @brigade_project = BrigadeProject.new
    general_static_response(@brigade_project)
  end

  # GET /brigade_projects/1/edit
  def edit
    @brigade_project = BrigadeProject.find(params[:id])
  end

  # POST /brigade_projects
  # POST /brigade_projects.json
  def create
    params[:brigade_project][:tags] = Tag.create_tags_from_string(params[:brigade_project][:tags])
    @brigade_project = BrigadeProject.new(params[:brigade_project])

    respond_to do |format|
      if @brigade_project.save
        render_successful_modification(format, @brigade_project, 'Brigade Project', :created)
      else
        render_failed_modification(format, 'new', @brigade_project.errors)
      end
    end
  end

  # PUT /brigade_projects/1
  # PUT /brigade_projects/1.json
  def update
    @brigade_project = BrigadeProject.find(params[:id])

    respond_to do |format|
      if @brigade_project.update_attributes(params[:brigade_project])
        render_successful_modification(format, @brigade_project, 'Brigade Project', :updated)
      else
        render_failed_modification(format, 'edit', @brigade_project.errors)
      end
    end
  end

  # DELETE /brigade_projects/1
  # DELETE /brigade_projects/1.json
  def destroy
    @brigade_project = general_destroy(BrigadeProject, params[:id], brigade_projects_url)
  end
end
