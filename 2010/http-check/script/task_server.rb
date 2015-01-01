#!/usr/bin/env ruby
# Runs site checks.

options = {}
ARGV.options do |opts|
  opts.on( "-e", "--environment ENVIRONMENT", String,
           "The Rails Environment to run under." ) do |environment|
    options[:environment] = environment
  end
  opts.parse!
end

RAILS_ENV = options[:environment] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'

if RAILS_ENV == "development" or RAILS_ENV == "test"
  SLEEP_TIME = 10
else
  SLEEP_TIME = 300
end

loop do
  begin
    SiteHelper::check_sites
  rescue Exception => e
    print "Top level exception: #{e.message}"
  end
  sleep(SLEEP_TIME)
end
