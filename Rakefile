task :environment do
	require 'sequel'
	DB = Sequel.connect('sqlite://blog.db')
	$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
	require 'post'
end

task :edit => :environment do
	post = Post.filter(:slug => ENV['SLUG']).first
	raise "No such post, specify with SLUG=" unless post

	require 'tempfile'
	fname = "/tmp/post_#{ENV['SLUG']}"
	File.open(fname, 'w') { |f| f.write post.body }
	system "vi #{fname}"
	post.body = File.read(fname)
	post.save
	File.delete(fname)
end
