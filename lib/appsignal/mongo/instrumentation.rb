module Appsignal
  module Mongo
    module Instrumentation
      EVENT_NAME = 'query.mongodb'.freeze

      private

      def instrument_with_appsignal_instrumentation(name, payload={}, &block)
        ActiveSupport::Notifications.instrument(
          EVENT_NAME, name => Marshal.load(Marshal.dump(payload))) do
            instrument_without_appsignal_instrumentation(name, payload, &block)
          end
      end

    end
  end
end
