task :environment do
	require 'sequel'
	DB = Sequel.connect('sqlite://blog.db')
	$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
	require 'post'
end

task :import => :environment do
	url = ENV['URL'] or raise "No url specified, use URL="

	require 'rest_client'
	posts = YAML.load RestClient.get(url)

	posts.each do |post|
		DB[:posts] << post
	end
end
