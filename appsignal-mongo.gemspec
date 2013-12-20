# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'appsignal/mongo/version'

Gem::Specification.new do |s|
  s.name          = 'appsignal-mongo'
  s.version       = Appsignal::Mongo::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Thijs Cadier', 'Steven Weller']
  s.email         = %w{contact@appsignal.com}

  s.homepage      = 'https://github.com/appsignal/appsignal-mongo'
  s.license       = 'MIT'

  s.summary       = 'Add instrument calls to mongodb queries '\
                    'made with mongo. For use with Appsignal.'
  s.description   = 'Wrap all mongo queries with'\
                    'ActiveSupport::Notifications.instrument calls. '\
                    'For use with Appsignal.'
  s.files         = Dir.glob('lib/**/*') + %w(README.md)

  s.require_path  = 'lib'

  s.add_dependency 'appsignal', '> 0.7'
  s.add_dependency 'mongo'

  s.add_development_dependency 'bson_ext' unless RUBY_PLATFORM == 'java'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
end
