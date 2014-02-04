require 'bundler/setup'
require 'json'

Bundler.require(:development)

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

SimpleCov.start

require 'wp2middleman'

RSpec.configure do |config|
  config.include CLIHelpers
end
