# frozen_string_literal: true

module ActionAlexa
  module RequestPayload
    # Session compontent of the JSON blob from the Alexa request TO the
    # application. This module contains utility methods to access the attributes
    module Session
      def new?
        session_payload.key?('new') && session_payload['new']
      end

      def session_id
        session_payload['sessionId']
      end

      def application_id
        session_payload['application']['applicationId']
      end

      def user_id
        session_payload['user']['userId']
      end

      def user_access_token_present?
        session_payload['user'].key?('accessToken')
      end

      def access_token
        session_payload['user']['accessToken']
      end

      private

      def session_payload
        alexa_payload['session']
      end
    end
  end
end
