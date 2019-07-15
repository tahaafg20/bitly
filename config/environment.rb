require 'bundler/setup'
require 'dotenv'
Bundler.require
unless ENV['RACK_ENV'] == "development"
ENV['SINATRA_ENV'] ||= "development"
Dotenv.load
end

require_all 'app'
