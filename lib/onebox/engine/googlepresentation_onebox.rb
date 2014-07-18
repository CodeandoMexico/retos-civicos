module Onebox
  module Engine
    class GooglepresentationOnebox
      include Engine
      include LayoutSupport
      include HTML


      matches_regexp(/^http:\/\/(?:www)\.docs\.google\.(?<tld>com)\/[a-zA-Z0-9]*\/presentation\//)

      def data
        puts @url
        {
          url: @url,
          name: raw.css("h1").inner_text,
          image: raw.css("#main-image").first["src"],
          description: raw.css("#postBodyPS").inner_text
        }
      end
    end
  end
end
