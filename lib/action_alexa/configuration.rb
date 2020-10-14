module ActionAlexa
  # Configuration class to support application code hooks within the ActionAlexa
  # gem. Configurations below that do not have hooks should be set within the
  # Rails initializers (app/config/initializers/*.rb). This class should be used
  # as a singleton instance through the ActionAlexa module
  class Configuration
    attr_writer :root, :current_user_hook, :logger,
                :default_intent_response_class

    MISSING_CURRENT_USER_HOOK_ERROR =
      'No block set for #current_user_hook to execute'.freeze
    MISSING_DEFAULT_INTENT_ERROR =
      'Default/Fallback Intent class not defined'.freeze

    # Consumers can either pass a block into #current_user_hook or explicitly
    #  create a lambda/proc and assign it via the writer #current_user_hook=
    def current_user_hook(&block)
      return @current_user_hook if current_user_hook?

      if block_given?
        @current_user_hook = block
        return
      end

      raise ActionAlexa::MissingConfiguration, MISSING_CURRENT_USER_HOOK_ERROR
    end

    def current_user_hook?
      !@current_user_hook.nil?
    end

    def root
      @root ||= Rails.root
    end

    def logger
      @logger ||= Rails.logger
    end

    # rubocop:disable Style/IfUnlessModifier - rubocop is having issues with
    #   the code below but its fairly succicient, so disabling the check here
    def default_intent_response_class
      if @default_intent_response_class.nil?
        raise ActionAlexa::MissingConfiguration, MISSING_DEFAULT_INTENT_ERROR
      end

      @default_intent_response_class
    end
    # rubocop:enable Style/IfUnlessModifier
  end
end
