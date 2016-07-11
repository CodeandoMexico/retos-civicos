module ControllersHelper
  def render_failed_modification(format, action, errors)
    format.html { render layout: 'aquila', action: action }
    format.json { render json: errors, status: :unprocessable_entity }
  end

  def render_successful_modification(format, resp, obj_name, created_or_updated)
    html_verb = created_or_updated.to_s
    if created_or_updated == :created
      format.json { render json: resp, status: created_or_updated, location: resp }
    elsif created_or_updated == :updated
      format.json { head :no_content }
    end
    format.html { redirect_to resp, notice: "#{obj_name} was successfully #{html_verb}." }
  end

  def general_destroy(object, id, url)
    destroyed_object = object.find(id)
    destroyed_object.destroy

    respond_to do |format|
      format.html { redirect_to url }
      format.json { head :no_content }
    end
    destroyed_object
  end

  def general_static_response(json_resp)
    respond_to do |format|
      format.html { render layout: 'aquila' }
      format.json { render json: json_resp }
    end
  end
end
