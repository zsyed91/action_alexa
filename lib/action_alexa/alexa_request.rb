require 'action_alexa/request_payload/session'
require 'action_alexa/request_payload/request'

module ActionAlexa
  # ActionAlexa::AlexaRequest is a wrapper around the actual request hash sent
  #   by the Alexa service. It provides utility accessor methods to extrapolate
  #   the request structure from Alexa from the application code that consumes
  #   this gem
  class AlexaRequest
    include ActionAlexa::RequestPayload::Session
    include ActionAlexa::RequestPayload::Request

    attr_reader :alexa_payload

    def initialize(alexa_payload)
      @alexa_payload = alexa_payload
    end
  end
end
