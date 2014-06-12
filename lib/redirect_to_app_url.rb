class RedirectToAppUrl
  def initialize(app)
    @app = app
    @app_name = ENV['APP_NAME']
    @app_url = ENV['APP_URL']
  end

  def call(env)
    if app_url && env['HTTP_HOST'].include?(app_name)
      [301, { 'Location' => url_to_redirect(env) }, ['Redirecting...']]
    else
      @app.call(env)
    end
  end

  private

  def url_to_redirect(env)
    request_url = Rack::Request.new(env).url
    request_url.gsub(/#{app_name}.herokuapp.com|#{app_name}.heroku.com/, app_url)
  end

  attr_reader :app_name, :app_url
end
