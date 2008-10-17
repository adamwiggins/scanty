require 'rubygems'
require 'sinatra'
require 'sequel'
require 'rdiscount'

DB = Sequel.connect('sqlite://blog.db')

begin
	DB.create_table :posts do
		column :title, :text
		column :body, :text
		column :slug, :text
		column :created_at, :timestamp
	end
rescue
end

get '/' do
	erb :index, :locals => { :posts => DB[:posts].reverse_order(:created_at).limit(10) }
end

get '/*:slug' do
	post = DB[:posts].filter(:slug => params[:slug]).first
	stop [ 404, "Page not found" ] unless post
	post[:body] = RDiscount.new(post[:body]).to_html
	erb :post, :locals => { :post => post }
end

