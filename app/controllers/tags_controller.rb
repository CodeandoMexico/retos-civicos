# TagsController directs the CRUD actions for
# Tag objects
class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
    general_static_response(@tags)
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])
    general_static_response(@tag)
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @tag = Tag.new
    general_static_response(@tag)
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        render_successful_modification(format, @tag, 'Tag', :created)
      else
        render_failed_modification(format, 'new', @tag.errors)
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        render_successful_modification(format, @tag, 'Tag', :updated)
      else
        render_failed_modification(format, 'edit', @tag.errors)
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = general_destroy(Tag, params[:id], tags_url)
  end
end
