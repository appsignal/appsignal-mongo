module Appsignal
  module Middleware
    class MongoEventSanitizer
      WHITELISTED_TOP_LEVEL_KEYS = [:fields, :order].freeze

      def call(event)
        if target?(event)
          event.payload.each_value do |parameters|
            selected(parameters).each_value do |value|
              scrub!(value)
            end
          end
        end
        yield
      end

      protected

      def target?(event)
        event.name == Appsignal::Mongo::Instrumentation::EVENT_NAME
      end

      def selected(parameters)
        parameters.reject do |key, value|
          WHITELISTED_TOP_LEVEL_KEYS.include?(key)
        end
      end

      def scrub!(value)
        if value.is_a?(Hash) || value.is_a?(Array)
          Appsignal::Transaction::ParamsSanitizer.scrub!(value)
        end
      end

    end
  end
end
