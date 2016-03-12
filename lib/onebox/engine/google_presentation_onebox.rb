module Onebox
  module Engine
    class GooglePresentationOnebox
      include Engine
      include LayoutSupport
      include HTML

      matches_regexp(/^(?<reference>http(s)?:\/\/docs\.google\.com\/(\S)*presentation\/d\/(\S)*\/)(\S)*/)

      def to_html
        "<iframe src=\"#{reference}embed?start=false&loop=false&delayms=3000\" frameborder=\"0\" width=\"960\" height=\"569\" allowfullscreen=\"true\" mozallowfullscreen=\"true\" webkitallowfullscreen=\"true\"></iframe>"
      end

      def reference
        @reference || @@matcher.match(@url)['reference']
      end

      def data
        {
          url: @url
        }
      end
    end
  end
end
