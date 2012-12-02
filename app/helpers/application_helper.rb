module ApplicationHelper
	def redirect_back_or(default, notice)
    redirect_to((session[:return_to] || default), notice: notice)
    clear_return_to
  end

  def store_location(url=request.fullpath)
    session[:return_to] = url
  end

  private

  def clear_return_to
    session.delete(:return_to)
  end
end
