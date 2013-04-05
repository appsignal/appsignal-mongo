module Appsignal
  module Mongo
    module Instrumentation
      EVENT_NAME = 'query.mongodb'

      private

      def instrument_with_appsignal_instrumentation(name, payload={}, &block)
        ActiveSupport::Notifications.instrument(
          EVENT_NAME, name => payload) do
            instrument_without_appsignal_instrumentation(name, payload, &block)
          end
      end

    end
  end
end
