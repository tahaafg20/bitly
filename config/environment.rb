require 'bundler/setup'
require 'dotenv'
Bundler.require

ENV['SINATRA_ENV'] ||= "development"
Dotenv.load

require_all 'app'
