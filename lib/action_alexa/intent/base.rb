# frozen_string_literal: true

require 'action_alexa/intent/authorization'

module ActionAlexa
  module Intent
    # Base Intent class which provides some basic sanity methods
    #   for the Skill intents defined by the application
    class Base
      class << self; attr_accessor :name end

      include ActionAlexa::Intent::Authorization

      attr_reader :alexa_payload, :alexa_response

      AMAZON_API_URL = 'https://api.amazon.com/user/profile'

      def initialize(alexa_payload)
        @alexa_payload = alexa_payload
        @alexa_response = ActionAlexa::Response.new
      end

      def execute
        raise 'Implement this method in your intent subclass'
      end
    end
  end
end
