class ApplicationController < ActionController::Base
  include ApplicationHelper
  include ControllersHelper

  protect_from_forgery
  before_filter :set_locale
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  rescue_from CanCan::AccessDenied do |_exception|
    store_location(request.env['HTTP_REFERER'])
    if user_signed_in?
      record_not_found
    else
      redirect_to signup_path, alert: t('flash.unauthorized.message')
    end
  end

  def set_locale
    I18n.locale = session[:locale] || 'es'
  end

  def after_sign_in_path_for(resource)
    return dashboard_url if resource.organization?
    return evaluations_path if resource.judge?
    return edit_current_user_path(resource.userable) if resource.just_created?
    session[:return_to] || challenges_path
  end

  def redirect_back_or(default, notice)
    redirect_to((session[:return_to] || default), notice: notice)
    clear_return_to
  end

  def store_location(url = request.fullpath)
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    # don't store ajax calls
    if request.fullpath != '/login' && (request.fullpath != '/logout' && !request.xhr?)
      session[:return_to] = url
    end
    session[:return_to] = url
  end

  def last_challenge
    @last_challenge ||= Challenge.last_created
  end

  helper_method :last_challenge

  def record_not_found
    render file: 'public/404.html', status: :not_found, layout: false
  end

  def edit_brigade_json(brigade_project)
    unless brigade_project.class.name == "BrigadeProject"
      raise Exceptions::InvalidBrigadeProjectError, 'Must be a valid project'
    end
    brigade_project_json = brigade_project.to_json({:include => [:tags => {:only => :name}]})
    { brigade_project: brigade_project_json,
      button_text: I18n.t('projects.update'),
      action_path: brigade_project_path(brigade_project) }
  end

  private

  def clear_return_to
    session.delete(:return_to)
  end
end
