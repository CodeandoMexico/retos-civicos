class HomeController < ApplicationController
  
  layout "home"

  def index
    @projects = Project.limit(3)
  end

  def sign_up 

  end
end
