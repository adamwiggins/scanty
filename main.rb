require 'rubygems'
require 'sinatra'
require 'sequel'

DB = Sequel.connect('sqlite://blog.db')

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'post'

get '/' do
	posts = Post.reverse_order(:created_at).limit(10)
	erb :index, :locals => { :posts => posts }
end

get '/past/:year/:month/:day/:slug/' do
	post = Post.filter(:slug => params[:slug]).first
	stop [ 404, "Page not found" ] unless post
	erb :post, :locals => { :post => post }
end

get '/past/:year/:month/:day/:slug' do
	redirect "/past/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:slug]}/", 301
end

get '/past' do
	posts = Post.reverse_order(:created_at)
	erb :archive, :locals => { :posts => posts }
end

get '/past/tags/:tag' do
	posts = Post.filter(:tags.like("%#{params[:tag]}%")).reverse_order(:created_at).limit(30)
	erb :index, :locals => { :posts => posts }
end

get '/feed' do
	@posts = Post.reverse_order(:created_at).limit(10)
	content_type 'application/atom+xml', :charset => 'utf-8'
	builder :feed
end

get '/rss' do
	redirect '/feed', 301
end

