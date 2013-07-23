module ApplicationHelper

  # Dynamic current userable method depending on the user's role
  # Example: if current_user is a member you can simply call current_member
  User::ROLES.each do |role|
    define_method "current_#{role.downcase}" do
      current_user.userable if user_signed_in?
    end
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

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
      underline: true,
      space_after_headers: true,
      highlight: true,
      lax_spacing: true,
      autolink: true,
      no_intra_emphasis: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  private

  def clear_return_to
    session.delete(:return_to)
  end
end
