require 'rubygems'
require 'sinatra'

Sinatra::Application.default_options.merge!(
  :run => false,
  :environment => :development,
  :raise_errors => true
)

#log = File.new("sinatra.log", "a")
#STDOUT.reopen(log)
#STDERR.reopen(log)

#see: http://groups.google.com/group/phusion-passenger/browse_thread/thread/9b9f0c21e$

log = File.new("sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)


require 'chat.rb'
run Sinatra.application