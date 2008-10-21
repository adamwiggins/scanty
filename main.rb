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
		column :tags, :text
		column :created_at, :timestamp
	end
rescue
end

helpers do
	def split_content(string)
		parts = string.gsub(/\r/, '').split("\n\n")
		show = []
		hide = []
		parts.each do |part|
			if show.join.length < 100
				show << part
			else
				hide << part
			end
		end
		[ RDiscount.new(show.join("\n\n")).to_html, hide.size > 0 ]
	end
end

get '/' do
	posts = DB[:posts].reverse_order(:created_at).limit(10)
	posts = posts.map do |post|
		post[:body], post[:more?] = split_content(post[:body])
		post
	end
	erb :index, :locals => { :posts => posts }
end

get '/feed' do
	posts = DB[:posts].reverse_order(:created_at).limit(10)
	@posts = posts.map do |post|
		post[:summary], post[:more?] = split_content(post[:body])
		post[:body] = RDiscount.new(post[:body]).to_html
		post
	end
	content_type 'application/atom+xml', :charset => 'utf-8'

	builder :feed
end

get '/*:slug' do
	post = DB[:posts].filter(:slug => params[:slug]).first
	stop [ 404, "Page not found" ] unless post
	post[:body] = RDiscount.new(post[:body]).to_html
	erb :post, :locals => { :post => post }
end
