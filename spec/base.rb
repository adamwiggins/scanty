require 'rubygems'
require 'spec'
require 'sequel'
require 'rdiscount'

DB = Sequel.sqlite

DB.create_table :posts do
	column :title, :text
	column :body, :text
	column :slug, :text
	column :tags, :text
	column :created_at, :timestamp
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'post'

