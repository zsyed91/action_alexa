require 'action_alexa/alexa_request'
require 'action_alexa/intent/registry'

module ActionAlexa
  # Top level class that will:
  #  1. Take in the Alexa request payload
  #  2. Fetch the intent Alexa is attempting to run
  #  3. Run the intent
  #  4. Return the response to Alexa for the end user
  # This class should be run within a Rails Controller to interface between
  # Alexa calls to the web service and intent executions
  class Skill
    attr_reader :alexa_payload, :logger

    MISSING_DEFAULT_INTENT_MESSAGE =
      'There was an error talking to the service'.freeze

    def initialize(alexa_payload)
      @alexa_payload = ActionAlexa::AlexaRequest.new(alexa_payload)
      @logger = ActionAlexa.config.logger
    end

    def self.execute(alexa_payload)
      new(alexa_payload).execute_skill
    end

    def execute_skill
      # Find the intent based on the registery intents
      intent_class = ActionAlexa::Intent::Registry.find_intent(
        alexa_payload.intent_name
      )

      return fallback_intent_response if intent_class.nil?

      intent = intent_class.new(alexa_payload)

      # Execute the intent and return the result back to Alexa
      intent.execute
    end

    private

    def fallback_intent_response
      logger.error(
        "Could not find the intent for #{alexa_payload.intent_name}"
      )

      begin
        intent_class = ActionAlexa.config.default_intent_response_class
        intent_class.new(alexa_payload).execute
      rescue ActionAlexa::MissingConfiguration => e
        logger.error(e.message)
        default_intent_response
      end
    end

    def default_intent_response
      response = ActionAlexa::Response.new
      response.say(MISSING_DEFAULT_INTENT_MESSAGE)
    end
  end
end
