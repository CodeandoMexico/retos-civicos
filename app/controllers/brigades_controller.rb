class BrigadesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_brigade, only: [:show, :edit, :update, :destroy]

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
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brigade }
    end
  end

  # GET /brigades/new
  # GET /brigades/new.json
  def new
    @brigade = Brigade.new

    respond_to do |format|
      format.html { render layout: 'aquila' }
      format.json { render json: @brigade }
    end
  end

  # GET /brigades/1/edit
  def edit
  end

  # POST /brigades
  # POST /brigades.json
  def create
    @brigade = Brigade.new(brigade_params)

    respond_to do |format|
      if @brigade.save
        format.html { redirect_to @brigade, notice: 'Brigade was successfully created.' }
        format.json { render json: @brigade, status: :created, location: @brigade }
      else
        format.html { render action: 'new' }
        format.json { render json: @brigade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brigades/1
  # PUT /brigades/1.json
  def update
    respond_to do |format|
      if @brigade.update_attributes(brigade_params)
        format.html { redirect_to @brigade, notice: 'Brigade was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @brigade.errors, status: :unprocessable_entity }
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

  def location_of_zip_code
    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { render json: Brigade.location_of_zip_code(params[:zip_code]) }
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
end
