require 'net/http'

module ActionAlexa
  module Intent
    # Module to allow adding basic authorization flow to Intents
    # This module interfaces between accessing the user profile from
    # Amazon and provide a callback to pull the application user
    # who matches the profile UUID provided by the Alexa service
    module Authorization
      AMAZON_API_URL = 'https://api.amazon.com/user/profile'.freeze

      # Utility method that allows upstream Intent classes to map the Amazon
      # user Alexa is calling as with the user account for your service.
      # Common mapping is to match the UUID from the Alexa payload against a
      # User object in your Users table
      # This method will call fetch_user with the amazon user id from the
      # request while fetch_user will execute any lambda passed into the
      # Configuration current_user_hook to perform the look up
      def current_user
        @current_user ||= fetch_user_from_request
      end

      def fetch_user_from_request
        fetch_user(profile['user_id'])
      end

      # Fetch the user object in your application that matches the user_id from
      #   the amazon request. The implementation for the look up is configurable
      #   by passing in a block to the Configuration.current_user_hook utilty
      # The Configuration.current_user_hook method will be invoked with the
      #   user_id from the Alexa payload
      def fetch_user(user_id)
        ActionAlexa.config.current_user_hook.call(user_id)
      end

      def fetch_amazon_user_profile(access_token)
        uri = URI.parse(AMAZON_API_URL)
        request = Net::HTTP::Get.new(uri.request_uri)
        request['Authorization'] = 'bearer ' + access_token
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        response = http.request(request)
        JSON.parse(response.body)
      end

      def profile
        @profile ||= fetch_amazon_user_profile(access_token)
      end

      def access_token
        @access_token ||= alexa_payload.access_token
      end
    end
  end
end
