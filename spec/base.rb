require 'rubygems'
require 'spec'
require 'sequel'
require 'rdiscount'

DB = Sequel.sqlite

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'post'

