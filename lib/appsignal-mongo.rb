require 'mongo'
require 'appsignal'
require 'appsignal/mongo/instrumentation'
require 'appsignal/middleware/mongo_event_sanitizer'

::Mongo::Logging.module_eval do
  include Appsignal::Mongo::Instrumentation

  alias_method :instrument_without_appsignal_instrumentation, :instrument
  alias_method :instrument, :instrument_with_appsignal_instrumentation
end

Appsignal.post_processing_middleware.add Appsignal::Middleware::MongoEventSanitizer
