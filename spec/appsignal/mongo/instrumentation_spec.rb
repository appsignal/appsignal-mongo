require 'spec_helper'

describe Appsignal::Mongo::Instrumentation do
  let(:event) { @events.pop }
  subject { event.payload }
  before(:all) do
    @connection = Mongo::Connection.new("localhost", 27017, :safe => true)
    @db         = @connection['mongo_test']
    @events     = []
    ActiveSupport::Notifications.subscribe('query.mongodb') do |*args|
      @events << ActiveSupport::Notifications::Event.new(*args)
    end
  end
  let(:the_id) { BSON::ObjectId.new }
  before { BSON::ObjectId.stub(:new => the_id) }

  context "instrument an insert" do
    before { @db[:users].insert({:name => 'test'}) }

    it { should == {
      :insert => {
        :database => 'mongo_test',
        :collection => 'users',
        :documents => [{
          :name => 'test',
          :_id => the_id
        }]
      }
    } }
  end

  context "instrument a find" do
    before { @db[:users].find(:name => 'Pete').to_a }

    it { should == {
      :find => {
        :database => 'mongo_test',
        :collection => 'users',
        :selector => {:name => 'Pete'}
      }
    } }
  end
end
