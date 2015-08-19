module Panel
  class CommentsController < BaseController
    before_filter :authenticate_member!
    before_filter :set_entry
    layout 'panel'

    def index
    end

    private

    def set_entry
      @entry = Entry.find(params[:entry_id])
    end
  end
end
