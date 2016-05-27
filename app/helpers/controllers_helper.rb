module ControllersHelper
  def render_failed_modification(format, action, errors)
    format.html { render layout: 'aquila', action: action }
    format.json { render json: errors, status: :unprocessable_entity }
  end
end
