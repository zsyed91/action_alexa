module ActionAlexa
  # The return values from this class will go to the Alexa service and let the
  # Alexa device announce the statements provided. There are hooks to onboard
  # and send user cards to the end user accounts
  class Response
    VERSION = '1.0'.freeze

    def initialize
      @payload = default_payload
    end

    def say(message, overrides = {})
      @payload[:response].merge!(
        outputSpeech: {
          type: 'PlainText',
          text: message
        },
        shouldEndSession: overrides.fetch(:should_end_session, true)
      )

      with_link_account_card if link_account_card?(overrides)

      @payload
    end

    def with_link_account_card
      @payload[:response].merge!(
        card: { type: 'LinkAccount' }
      )

      self
    end

    private

    def link_account_card?(overrides)
      overrides.key?(:link_account_card) && overrides[:link_account_card]
    end

    def default_payload
      {
        version: VERSION,
        response: {},
        sessionAttributes: {}
      }
    end
  end
end
