xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
	xml.title "a tornado of razorblades"
	xml.id request.url
	xml.updated @posts.first[:created_at].iso8601 if @posts.any?
	xml.author { xml.name "Adam Wiggins" }

	@posts.each do |post|
		xml.entry do
			xml.title post[:title]
			xml.link "rel" => "alternate", "href" => post.url
			xml.id post.url
			xml.published post[:created_at].iso8601
			xml.updated post[:created_at].iso8601
			xml.author { xml.name "Adam Wiggins" }
			xml.summary post.summary_html, "type" => "html"
			xml.content post.body_html, "type" => "html"
		end
	end
end
