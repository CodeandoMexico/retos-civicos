module Onebox
  module Engine
    class GooglePresentationOnebox
      include Engine
      include LayoutSupport
      include HTML

      matches_regexp(/^http(s)?:\/\/docs\.google\.com\/(\S)*presentation\/(\S)*/)

      def to_html
        "<iframe src=\"#{@url}\" frameborder=\"0\" width=\"960\" height=\"569\" allowfullscreen=\"true\" mozallowfullscreen=\"true\" webkitallowfullscreen=\"true\"></iframe>"
      end

      def data
        {
          url: @url,
        }
      end
    end
  end
end
