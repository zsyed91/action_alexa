module ActionAlexa
  module Intent
    # The registry will auto-discover and auto-load and intent files found
    # within the intents folder (configurable). Default path to search is
    # Rails.root/app/intents/*_intents.rb
    # The classes loaded should inherit from ActionAlexa::Intent::Base
    class Registry
      def self.intents
        @intents ||= {}
      end

      def self.register_intent(intent)
        intents[intent] = intent.constantize
      end

      def self.find_intent(intent)
        load_registry! if intents.empty?

        intent_name = "#{intent}Intent"
        intents[intent_name]
      end

      def self.load_registry!
        intents_path = File.join(
          ActionAlexa.config.root, 'app', 'intents', '*_intent.rb'
        )
        Dir.glob(intents_path).sort.each do |intent_file|
          require intent_file
          class_name = intent_file.split('/').last.gsub(/\.rb/, '')
          register_intent(class_name.split('_').collect(&:capitalize).join)
        end
      end
    end
  end
end
