require File.dirname(__FILE__) + '/base'

describe Post do
	before do
		@post = Post.new
	end

	it "has a url in simplelog format: /past/2008/10/17/my_post/" do
		@post.created_at = Time.now
		@post.slug = "my_post"
		@post.url.should == '/past/2008/10/22/my_post/'
	end

	it "produces html from the markdown body" do
		@post.body = "* Bullet"
		@post.body_html.should == "<ul>\n<li>Bullet</li>\n</ul>\n\n"
	end

	it "gets rid of the newline after the code tag, since code is set to whitespace: pre" do
		@post.to_html("<code>\none\ntwo</code>").should == "<p><code>one\ntwo</code></p>\n"
	end

	it "makes the tags into links to the tag search" do
		@post.tags = "one two"
		@post.linked_tags.should == '<a href="/past/tags/one">one</a> <a href="/past/tags/two">two</a>'
	end
end
