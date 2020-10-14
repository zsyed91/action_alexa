require 'active_support/inflector'

require 'action_alexa/version'
require 'action_alexa/intent/base'
require 'action_alexa/intent/registry'
require 'action_alexa/request_payload/request'
require 'action_alexa/request_payload/session'
require 'action_alexa/alexa_request'
require 'action_alexa/response'
require 'action_alexa/configuration'
require 'action_alexa/exceptions'
require 'action_alexa/skill'

require 'action_alexa/railtie' if defined?(Rails)

# Base
module ActionAlexa
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= ActionAlexa::Configuration.new

    yield config if block_given?
  end
end
