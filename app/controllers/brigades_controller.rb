# Controller for the Brigades object. Must be authenticated to view.
class BrigadesController < ApplicationController
  include BrigadesHelper
  before_filter :authenticate_user!
  before_filter :set_brigade, only: [:show, :edit, :update, :destroy]

  def follow
    BrigadeUser.follow_unfollow(params[:userid], params[:brigadeid])
    render nothing: true
  end
  
  # GET /brigades
  # GET /brigades.json
  def index
    @brigades = Brigade.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brigades }
    end
  end

  # GET /brigades/1
  # GET /brigades/1.json
  def show
    @current_user = current_user
    @user_joined = user_in_brigade?(@current_user, params[:id])
    @brigade_id = params[:id]
    render_brigade
  end

  # GET /brigades/new
  # GET /brigades/new.json
  def new
    @brigade = Brigade.new
    render_brigade
  end

  # GET /brigades/1/edit
  def edit
    render layout: 'aquila'
  end

  # POST /brigades
  # POST /brigades.json
  def create
    @brigade = Brigade.new(brigade_params)

    respond_to do |format|
      if @brigade.save
        format.html { redirect_to @brigade, notice: I18n.t('brigades.new.success') }
        format.json { render json: @brigade, status: :created, location: @brigade }
      else
        render_failed_modification(format, 'new', @brigade.errors)
      end
    end
  end

  # PUT /brigades/1
  # PUT /brigades/1.json
  def update
    respond_to do |format|
      if @brigade.update_attributes(brigade_params)
        format.html { redirect_to @brigade, notice: I18n.t('brigades.edit.success') }
        format.json { head :no_content }
      else
        render_failed_modification(format, 'edit', @brigade.errors)
      end
    end
  end

  # DELETE /brigades/1
  # DELETE /brigades/1.json
  def destroy
    @brigade.destroy

    respond_to do |format|
      format.html { redirect_to brigades_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_brigade
    @brigade = Brigade.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def brigade_params
    strong_params = params[:brigade]
    strong_params[:user] = current_user
    strong_params
  end

  def render_brigade
    respond_to do |format|
      format.html { render layout: 'aquila' }
      format.json { render json: @brigade }
    end
  end
end
