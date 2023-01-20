module Panel
  class EntriesController < BaseController
    before_filter :authenticate_member!
    layout 'panel'

    def index
      @entries = current_user.userable.entries.map { |e| EntryDecorator.new(e) }
    end
  end
end
