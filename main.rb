require 'rubygems'
require 'sinatra'
require 'sequel'

DB = Sequel.sqlite
DB.create_table :posts do
	column :title, :text
	column :body, :text
	column :created_at, :timestamp
end

DB[:posts] << { :title => "Erlang", :body => "Lorum ipsum", :created_at => Time.now }
DB[:posts] << { :title => "DDL Transactions", :body => "Lorum ipsum 2", :created_at => Time.now }

get '/' do
	erb :index, :locals => { :posts => DB[:posts] }
end

