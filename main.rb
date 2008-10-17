require 'rubygems'
require 'sinatra'
require 'sequel'

DB = Sequel.sqlite
DB.create_table :posts do
	column :title, :text
	column :body, :text
	column :slug, :text
	column :created_at, :timestamp
end

DB[:posts] << { :title => "Erlang", :body => "Lorum ipsum", :created_at => Time.now, :slug => "1-erlang" }
DB[:posts] << { :title => "DDL Transactions", :body => "Lorum ipsum 2", :created_at => Time.now, :slug => "2-ddl-transactions" }

get '/' do
	erb :index, :locals => { :posts => DB[:posts] }
end

get '/*:slug' do
	post = DB[:posts].filter(:slug => params[:slug]).first
	stop [ 404, "Page not found" ] unless post
	erb :post, :locals => { :post => post }
end

