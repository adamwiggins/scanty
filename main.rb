require 'rubygems'
require 'sinatra'
require 'sequel'

DB = Sequel.connect('sqlite://blog.db')

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'post'

layout 'layout'

get '/' do
	posts = Post.reverse_order(:created_at).limit(10)
	erb :index, :locals => { :posts => posts }, :layout => false
end

get '/past/:year/:month/:day/:slug/' do
	post = Post.filter(:slug => params[:slug]).first
	stop [ 404, "Page not found" ] unless post
	erb :post, :locals => { :post => post, :title => post.slug }
end

get '/past/:year/:month/:day/:slug' do
	redirect "/past/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:slug]}/", 301
end

get '/past' do
	posts = Post.reverse_order(:created_at)
	erb :archive, :locals => { :posts => posts, :title => "Archive" }
end

get '/past/tags/:tag' do
	tag = params[:tag]
	posts = Post.filter(:tags.like("%#{tag}%")).reverse_order(:created_at).limit(30)
	erb :tagged, :locals => { :posts => posts, :title => "Posts tagged #{tag}", :tag => tag }
end

get '/feed' do
	@posts = Post.reverse_order(:created_at).limit(10)
	content_type 'application/atom+xml', :charset => 'utf-8'
	builder :feed
end

get '/rss' do
	redirect '/feed', 301
end

