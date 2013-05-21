module ApplicationHelper

  # Dynamic current userable method depending on the user's role
  # Example: if current_user is a member you can simply call current_member
  User::ROLES.each do |role|
    define_method "current_#{role.downcase}" do
      current_user.userable if signed_in?
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    current_user.present?
  end

  def edit_current_user_path(user, new_user = nil)
    send("edit_#{user.class.name.downcase}_path", user, new_user) 
  end

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
