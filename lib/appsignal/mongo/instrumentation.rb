module Appsignal
  module Mongo
    module Instrumentation
      EVENT_NAME = 'query.mongodb'.freeze

      def self.deep_clone(value)
        case value
        when Hash
          result = {}
          value.each { |k, v| result[k] = deep_clone(v) }
          result
        when Array
          value.map { |v| deep_clone(v) }
        when Symbol, Numeric, true, false, nil
          value
        else
          value.clone
        end
      end

      private

      def instrument_with_appsignal_instrumentation(name, payload={}, &block)
        ActiveSupport::Notifications.instrument(
          EVENT_NAME,
          name => Appsignal::Mongo::Instrumentation.deep_clone(payload)
        ) do
          instrument_without_appsignal_instrumentation(name, payload, &block)
        end
      end

    end
  end
end
