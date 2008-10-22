require 'rubygems'
require 'spec'
require 'sequel'

DB = Sequel.sqlite

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'post'

