class BrigadeProjectsController < ApplicationController
  # GET /brigade_projects
  # GET /brigade_projects.json
  def index
    @brigade_projects = BrigadeProject.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brigade_projects }
    end
  end

  # GET /brigade_projects/1
  # GET /brigade_projects/1.json
  def show
    @brigade_project = BrigadeProject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brigade_project }
    end
  end

  # GET /brigade_projects/new
  # GET /brigade_projects/new.json
  def new
    @brigade_project = BrigadeProject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @brigade_project }
    end
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
        format.html { redirect_to @brigade_project, notice: 'Brigade project was successfully created.' }
        format.json { render json: @brigade_project, status: :created, location: @brigade_project }
      else
        format.html { render action: "new" }
        format.json { render json: @brigade_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brigade_projects/1
  # PUT /brigade_projects/1.json
  def update
    @brigade_project = BrigadeProject.find(params[:id])

    respond_to do |format|
      if @brigade_project.update_attributes(params[:brigade_project])
        format.html { redirect_to @brigade_project, notice: 'Brigade project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @brigade_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brigade_projects/1
  # DELETE /brigade_projects/1.json
  def destroy
    @brigade_project = BrigadeProject.find(params[:id])
    @brigade_project.destroy

    respond_to do |format|
      format.html { redirect_to brigade_projects_url }
      format.json { head :no_content }
    end
  end
end
