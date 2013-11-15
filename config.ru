require 'bundler/setup'

Bundler.require(:default)

require 'sinatra/config_file'
require 'sinatra/reloader'

Dir["#{File.dirname(__FILE__)}/lib/*.rb"].sort.each do |file|
  require file
end

require File.join(File.dirname(__FILE__), 'server')

run Server
