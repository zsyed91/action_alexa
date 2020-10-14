# frozen_string_literal: true

module ActionAlexa
  module RequestPayload
    # Request component of the JSON blob from the Alexa request TO the
    # application. This module contains utility methods to access the attributes
    module Request
      def type
        request_payload['type']
      end

      def intent_name
        return type unless type == 'IntentRequest'

        full_intent_name = request_payload['intent']['name']
        full_intent_name.split(/\./).last.gsub(/Intent$/, '')
      end

      # For logging purposes when reaching out to Amazon
      def request_id
        request_payload['requestId']
      end

      def timestamp
        request_payload['timestamp']
      end

      def locale
        request_payload['locale']
      end

      def link_result_should_be_returned?
        key = 'shouldLinkResultBeReturned'

        request_payload.key?(key) && request_payload[key]
      end

      def slots?
        !slots.nil?
      end

      def slot?(slot_type)
        slots? && !slot(slot_type).nil?
      end

      def slot(slot_type)
        return nil unless slots?

        slots[slot_type]
      end

      def slots
        request_payload['intent']['slots']
      end

      private

      def request_payload
        alexa_payload['request']
      end
    end
  end
end
