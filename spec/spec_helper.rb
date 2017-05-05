require './whoaz'
require 'rspec'
require 'rack/test'
require 'json_spec'

set :environment, :test

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include JsonSpec::Helpers
end
