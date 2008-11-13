require File.dirname(__FILE__) + "/../main.rb"

set_option :run, false
set_option :env, ENV['APP_ENV'] || :production

run Sinatra.application
