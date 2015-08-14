module Panel
  class EntriesController < BaseController
    before_filter :authenticate_member!
    layout 'panel'

    def index
      @member = current_user.userable # for short typing in the view
    end
  end
end
