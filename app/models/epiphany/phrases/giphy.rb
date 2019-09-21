module Epiphany
  module Phrases
    module Giphy
      require 'httparty'

      #TODO obv remove this into an env var? / init config
      API_KEY = 'DVb3XIqhUij6tnUFCr8bvVatfSZKHx0X'
      UNKNOWN_GIPHY = 'https://media1.giphy.com/media/3o6vXV1AQ9lABhHjJS/giphy.gif?cid=790b7611f0627c62b6b73b62bebd358b090e1d759c5921be&rid=giphy.gif'

      def get_giphy
        url = "https://api.giphy.com/v1/gifs/search?api_key=#{API_KEY}&q=#{phrase}&limit=25&offset=0&rating=G&lang=en"
        res = ::HTTParty.get(url)
        random = res['data'].sample
        random&.dig('images', 'original', 'url') || UNKNOWN_GIPHY
      end

    end
  end
end
