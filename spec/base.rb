require 'rubygems'
require 'spec'
require 'sequel'

DB = Sequel.sqlite

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'post'

require 'ostruct'
Blog = OpenStruct.new(
	:title => 'My blog',
	:author => 'Anonymous Coward',
	:url_base => 'http://blog.example.com/'
)
