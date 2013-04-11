require 'spec_helper'

describe Appsignal::Middleware::MongoEventSanitizer do
  def sanitize
    mongo_event_sanitizer.call(event) { }
  end
  let(:mongo_event_sanitizer) { Appsignal::Middleware::MongoEventSanitizer.new }
  let(:event) { @events.pop }
  subject { sanitize; event.payload }
  before(:all) do
    @connection = Mongo::Connection.new("localhost", 27017, :safe => true)
    @db         = @connection['mongo_test']
    @events     = []
    ActiveSupport::Notifications.subscribe do |*args|
      @events << ActiveSupport::Notifications::Event.new(*args)
    end
  end

  context "sanitizizing query.mongodb events" do
    context "sanitize an insert" do
      before { @db[:users].insert({:name => 'test'}) }

      it { should == {
        "insert in 'users'" => {
          :database => 'mongo_test',
          :collection => 'users',
          :documents => [{
            :name => '?',
            :_id => '?'
          }]
        }
      } }
    end

    context "instrument a find" do
      before do
        @db[:users].find(
          {:name => 'Pete'},
          :fields => [:name],
          :sort => [[:name, Mongo::ASCENDING]]
        ).to_a
      end

      it { should == {
        "find in 'users'" => {
          :database => 'mongo_test',
          :collection => 'users',
          :selector => {:name => '?'},
          :fields => {:name => 1},
          :order => [[:name, 1]]
        }
      } }
    end

    context "sanitize an update" do
      before do
        @db[:users].update({:name => 'test'}, {:age => 33})
      end

      it { should == {
        "update in 'users'" => {
          :database => 'mongo_test',
          :collection => 'users',
          :selector => {:name => '?'},
          :document => {:age => '?'}
        }
      } }
    end

    context "sanitize a remove" do
      before do
        @db[:users].remove({:name => 'test'})
      end

      it { should == {
        "remove in 'users'" => {
          :database => 'mongo_test',
          :collection => 'users',
          :selector => {:name => '?'},
        }
      } }
    end
  end

  context "do not sanitize other events" do
    before do
      ActiveSupport::Notifications.instrument(
        'something else',
        :a => {:deep => {:nested => [:hash]}}
      )
    end

    it { should == {:a => {:deep => {:nested => [:hash]}}} }
  end
end
