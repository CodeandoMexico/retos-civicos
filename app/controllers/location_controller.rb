class LocationController < ApplicationController
  def location_name
    respond_to do |format|
      format.json { render json: { data: Location.title(params[:location_id]) } }
    end
  end
  
  def location_unique
    selected_location = ""
    exists = false
    
    selected_location = Location.find(params[:location_id])
    exists = Brigade.exists?(location_id: params[:location_id])
    
    respond_to do |format|
      format.json { render json: { data: exists } }
    end
  end

  def location_search
    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { render json: Location.search(params[:location_query]) }
    end
  end
end
